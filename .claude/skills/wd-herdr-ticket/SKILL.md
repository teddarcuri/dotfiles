---
name: wd-herdr-ticket
description: Open a Herdr worktree workspace for a WD Jira ticket — Agents tab (impl + reviewer running wd-start-ticket) and Servers tab (repo-configured). If no ticket key is given, lists your active sprint tickets first.
allowed-tools: Bash
---

# wd-herdr-ticket

Create a two-tab Herdr workspace for a WD ticket. The workspace gets its own git worktree on the
real ticket branch (e.g. `WD-3703/prevent-zero-dollar-bundles`), an Agents tab with an impl
agent running `/wd-start-ticket` and a reviewer agent on standby, and a Servers tab with any
servers defined in `.herdr/config.json`.

## When to Use

Run at the start of a WD ticket when you want an isolated workspace with dedicated agents. Must
be invoked from inside a Herdr-managed pane (`HERDR_ENV=1`).

## Arguments

`$ARGUMENTS` — WD ticket key, e.g. `WD-3703` or bare `3703`. Optional — if omitted, your active
sprint tickets are listed and you pick one.

## Workflow

### 1. Verify the Herdr environment

```bash
test "${HERDR_ENV:-}" = 1 || {
  echo "Error: not running inside Herdr. Launch this skill from a Herdr-managed pane."
  exit 1
}
```

### 2. Resolve the ticket key

If `$ARGUMENTS` is empty, invoke [[wd-tickets]] to list your active sprint WD tickets and prompt
for a selection. Use the selected key as the ticket key for the rest of this workflow.

If `$ARGUMENTS` is provided, normalize it:

```bash
NUM=$(printf '%s' "$ARGUMENTS" | sed 's/^[Ww][Dd]-//')
KEY="WD-$NUM"
```

### 3. Fetch ticket title and build the branch name

Fetch the ticket summary from Jira:

```bash
jira issue view "$KEY" --plain 2>/dev/null | head -5
```

Derive a concise slug from the title using judgment — 3 to 5 key words, lowercase, hyphen-separated.
Match the style used by `wd-start-ticket`: e.g. "Prevent users from checking out with $0.00 bundles"
→ `prevent-zero-dollar-bundles`. Do not mechanically transcribe every word.

Set `BRANCH="$KEY/$SLUG"`. If the Jira fetch fails, fall back to `BRANCH="$KEY"`.

### 4. Derive agent names

```bash
AGENT_KEY=$(printf '%s' "$KEY" | tr '[:upper:]' '[:lower:]' \
  | sed 's/[^a-z0-9]/-/g; s/-\+/-/g; s/-$//')
IMPL_NAME="impl-$AGENT_KEY"
REVIEWER_NAME="reviewer-$AGENT_KEY"
```

Both names must satisfy `[a-z][a-z0-9_-]{0,31}`. Truncate `$AGENT_KEY` from the right if either
exceeds 32 characters.

### 5. Read server config

```bash
SERVER_JSON=$(cat .herdr/config.json 2>/dev/null)
```

Extract each server's `name`, `command`, and `ask` flag. For any server where `ask` is `true`,
use `AskUserQuestion` to confirm whether to start it. Build `$ACTIVE_SERVERS` as the confirmed
list. If no config exists, `$ACTIVE_SERVERS` is empty.

### 6. Discover available agent kinds

```bash
herdr agent
```

Identify the Claude Code kind label. Capture as `$AGENT_KIND`. Do not hardcode a kind name.

### 7. Create the worktree workspace

```bash
WORKTREE_RESPONSE=$(herdr worktree create \
  --branch "$BRANCH" \
  --base main \
  --label "$KEY" \
  --no-focus)
```

Parse all IDs from the JSON response — never predict or hardcode them:

```bash
WORKSPACE_ID=$(printf '%s' "$WORKTREE_RESPONSE" | jq -r '.result.workspace.workspace_id')
AGENTS_TAB_ID=$(printf '%s' "$WORKTREE_RESPONSE" | jq -r '.result.tab.tab_id')
ROOT_PANE_ID=$(printf '%s' "$WORKTREE_RESPONSE" | jq -r '.result.root_pane.pane_id')
WORKTREE_PATH=$(printf '%s' "$WORKTREE_RESPONSE" | jq -r '.result.worktree.path // .result.workspace.worktree_path')
```

Stop if any value is empty or `null`; print the full JSON for diagnosis.

### 8. Copy env files and install dependencies

Worktrees do not share `node_modules` or env files with the primary checkout. The repo root of
the primary checkout is available as the `source_checkout_path` from `herdr worktree list`.
Determine the main checkout path (it is the non-linked worktree for this repo) and copy all env
files across before installing:

```bash
# Identify main checkout path from worktree list
MAIN=$(herdr worktree list | jq -r '.result.source.source_checkout_path')

# Copy root env files (e.g. .env, .env.local)
for f in "$MAIN"/.env "$MAIN"/.env.local "$MAIN"/.env.*; do
  [ -f "$f" ] && cp "$f" "$WORKTREE_PATH/"
done

# Copy sanity env files if sanity/ exists in both
if [ -d "$MAIN/sanity" ] && [ -d "$WORKTREE_PATH/sanity" ]; then
  for f in "$MAIN"/sanity/.env "$MAIN"/sanity/.env.*; do
    [ -f "$f" ] && cp "$f" "$WORKTREE_PATH/sanity/"
  done
fi
```

Then install dependencies:

```bash
herdr pane run "$ROOT_PANE_ID" "pnpm install"
herdr pane wait-output "$ROOT_PANE_ID" --match "Done" --timeout 120000
```

If `sanity/package.json` exists in the worktree, install there too:

```bash
if [ -f "$WORKTREE_PATH/sanity/package.json" ]; then
  herdr pane run "$ROOT_PANE_ID" "cd sanity && pnpm install && cd .."
  herdr pane wait-output "$ROOT_PANE_ID" --match "Done" --timeout 120000
fi
```

### 9. Label the Agents tab

```bash
herdr tab rename "$AGENTS_TAB_ID" "Agents"
```

### 10. Build the Agents tab layout

Split the root pane right for the reviewer. Use `--no-focus` and `--cwd "$WORKTREE_PATH"`.

```bash
REVIEWER_RESPONSE=$(herdr pane split \
  --pane "$ROOT_PANE_ID" \
  --direction right \
  --cwd "$WORKTREE_PATH" \
  --no-focus)
REVIEWER_PANE_ID=$(printf '%s' "$REVIEWER_RESPONSE" | jq -r '.result.pane.pane_id')
```

Layout: `[impl | reviewer]`.

### 11. Create the Servers tab

```bash
SERVERS_TAB_RESPONSE=$(herdr tab create \
  --workspace "$WORKSPACE_ID" \
  --label "Servers" \
  --no-focus)
SERVERS_TAB_ROOT_PANE=$(printf '%s' "$SERVERS_TAB_RESPONSE" | jq -r '.result.root_pane.pane_id')
```

For each server in `$ACTIVE_SERVERS`, use `$SERVERS_TAB_ROOT_PANE` for the first and split down
from the previous pane for each subsequent one. Before running the command, pick a free port:

```bash
PORT=$(python3 -c "import socket; s=socket.socket(); s.bind(('',0)); print(s.getsockname()[1]); s.close()")
```

Inject `--port $PORT` into the server command (append it for `pnpm dev`-style commands). Then run:

```bash
herdr pane run "$PANE_ID" "$SERVER_COMMAND --port $PORT"
```

Wait for the server to confirm it's listening, then rename the pane to include the port so it's
visible in the Herdr sidebar:

```bash
herdr pane wait-output "$PANE_ID" --match "localhost" --timeout 60000
herdr pane rename "$PANE_ID" "$SERVER_NAME :$PORT"
```

If `$ACTIVE_SERVERS` is empty, the Servers tab has one idle shell pane at `$WORKTREE_PATH`.

### 12. Start the agents

```bash
herdr agent start "$IMPL_NAME"     --kind "$AGENT_KIND" --pane "$ROOT_PANE_ID"
herdr pane rename "$ROOT_PANE_ID" "implementer"

herdr agent start "$REVIEWER_NAME" --kind "$AGENT_KIND" --pane "$REVIEWER_PANE_ID"
herdr pane rename "$REVIEWER_PANE_ID" "reviewer"
```

Stop if either `agent start` times out (30 s default). Rename immediately after each confirms
ready — the pane label overrides the terminal title Claude Code sets.

### 13. Send opening prompts

**Reviewer** — orientation:

```bash
herdr agent prompt "$REVIEWER_NAME" \
  "You are in review standby for ticket $KEY. Wait until the impl agent has produced meaningful work before reviewing. Do not start anything on your own."
```

**Impl** — queue the ticket skill. Omit `--wait`; `wd-start-ticket` is long and interactive:

```bash
herdr agent prompt "$IMPL_NAME" "/wd-start-ticket $KEY"
```

Note: `wd-start-ticket` will try `git checkout main`, which fails in a worktree. When the impl
agent hits this error, tell it:

> Skip `git checkout main`. The branch `$BRANCH` is already created. Run
> `git fetch origin main && git merge origin/main` to sync, then continue.

### 14. Report and hand back focus

Print:
- Workspace ID, worktree path, branch (`$BRANCH`)
- Agents tab: impl `$IMPL_NAME` (pane `$ROOT_PANE_ID`), reviewer `$REVIEWER_NAME`
- Servers tab: running servers with pane IDs; any servers skipped
- Reminder about the `git checkout main` workaround if applicable

User focus is unchanged throughout.

## Guardrails

- Abort at step 1 if `HERDR_ENV` is not `1`.
- Parse all IDs from JSON responses — never predict or hardcode them.
- Use `--no-focus` on every `pane split`, `tab create`, and `worktree create`.
- Omit `--wait` on the impl agent prompt.
- Do not close any workspace, tab, or pane created by this skill.
- Validate agent names satisfy `[a-z][a-z0-9_-]{0,31}` before calling `agent start`.
- On any Herdr CLI error (JSON on stderr, exit 1), print the error and stop.
