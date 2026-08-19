# Global Git Commit Rules

## CRITICAL: NO AI ATTRIBUTION

**NEVER add ANY AI or Claude attribution to git commits under ANY circumstance.**

This includes:
- NO "Generated with Claude Code" messages
- NO "Co-Authored-By: Claude" attribution
- NO mention of AI assistance whatsoever
- NO emojis related to AI/bots (🤖)
- NO links to Claude or AI services

Commits must appear as if written entirely by a human developer without any indication of AI involvement.

## Commit Message Format

Write clear, concise commit messages:
- Present tense, imperative mood ("Add feature" not "Added feature")
- Focus on what changed and why
- Multi-line format for complex changes (summary line + detailed body)

## Project: Centauri (`Sites/spaceforce/centauri`)

Overrides for skills and git workflow when working in this project.

### Branch Strategy (overrides start-ticket and all git workflow skills)

Centauri uses a linear promotion model. **Feature branches target `develop`, not `main`.**

```
feature/* → MR → develop → MR (+ version bump) → main → stage → production
```

**Rules**:
- **Always branch from `develop`**: `git checkout develop && git pull && git checkout -b {branch}`
- **Feature MRs target `develop`** — never target `main` directly from a feature branch
- **Version bump does NOT go on the feature branch** — it belongs on the `develop → main` MR
- **Branch naming**: `{initials}/{ticket-number}-{slug}` (e.g., `ta/976-rssi-full-strength`)
- **MR title = squash commit = release note** — must follow Conventional Commits, enforced by GitLab push rules: `feat | fix | chore | refactor | ci | docs | perf | test`
- **No version field in feature MR descriptions** — version bump is a separate concern
