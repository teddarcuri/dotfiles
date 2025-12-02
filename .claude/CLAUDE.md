<!--
NOTE: This is PROJECT-LEVEL configuration for the .dotfiles repository only.
GLOBAL Claude Code configuration lives at ~/.claude/CLAUDE.md (symlinked to shared/claude/CLAUDE.md)
-->

# .dotfiles Architecture Rules

## Shared vs Platform-Specific Paradigm

This repository follows a strict architectural pattern to minimize duplication and maintain consistency.

### Shared Components

**Location**: `/shared/` directory or root level config files
**Setup**: Handled in main `setup.sh` file's "Shared setup tasks" section
**Use for**: Configurations and setup that are IDENTICAL across all platforms

Examples:
- Oh My Zsh, Powerlevel10k, zsh plugins (used by shared `.zshrc`)
- Tmux Plugin Manager (used by shared `.tmux.conf`)
- Neovim configuration (`/shared/nvim/`)
- Cross-platform app configs (ghostty, btop, glow in `/apps/`)
- Shell utilities (`/shared/shell/`: env.sh, aliases.sh, functions.sh)

### Platform-Specific Components

**Location**: `/macos/` or `/linux/` directories
**Setup**: Handled in `macos/setup-macos.sh` or `linux/setup-linux.sh`
**Use for**: Configurations that DIFFER between platforms

Examples:
- Package manager operations (Homebrew for macOS, DNF for Linux)
- Platform-specific window managers (Niri for Linux/Wayland)
- Platform-specific package lists
- OS-specific system configurations

### Decision Criteria

Before adding setup code, evaluate:

1. **Are installation commands byte-for-byte identical?** → SHARED
2. **Is it used by a shared config file?** → SHARED
3. **Does it use platform-specific package managers?** → PLATFORM-SPECIFIC
4. **Does behavior differ between platforms?** → PLATFORM-SPECIFIC

**Default to SHARED unless there's a concrete platform-specific reason.**

### Anti-Pattern: Duplication

**NEVER duplicate identical setup code in both `macos/setup-macos.sh` and `linux/setup-linux.sh`.**

If code is identical, it MUST be moved to the shared section in `setup.sh`.

## Repository Structure

```
.dotfiles/
├── .zshrc                    # Shared zsh config (symlinked)
├── .zshenv                   # Shared zsh env
├── .bashrc                   # Shared bash config
├── setup.sh                  # Main entry point (calls platform scripts)
├── shared/                   # Shared cross-platform configs
│   ├── shell/               # env.sh, aliases.sh, functions.sh
│   ├── nvim/                # Neovim configuration
│   ├── tmux/                # .tmux.conf
│   └── git/                 # .gitconfig
├── macos/                    # macOS-specific
│   ├── setup-macos.sh       # macOS setup script
│   ├── Brewfile             # Homebrew package list
│   └── shell/               # Platform-specific shell configs
├── linux/                    # Linux-specific
│   ├── setup-linux.sh       # Linux setup script
│   ├── packages.dnf         # DNF package list
│   ├── copr.repos           # COPR repositories
│   ├── apps/niri/           # Niri window manager config
│   └── shell/               # Platform-specific shell configs
├── profiles/                 # Work/personal environment profiles
│   ├── work-sram/
│   └── personal/
└── apps/                     # Cross-platform application configs
    ├── ghostty/
    ├── btop/
    └── glow/
```

## Profile System

Supports multiple profiles for work/personal separation:
- Git identity switching
- Profile-specific aliases and environment variables
- Activated via `.dotfiles-profile` file

## Setup Flow

1. `setup.sh` detects platform (macOS or Linux)
2. Sources appropriate platform script (`macos/setup-macos.sh` or `linux/setup-linux.sh`)
3. Platform script runs platform-specific setup
4. Control returns to `setup.sh` for shared setup tasks
5. User selects profile
6. Configs are symlinked to home directory
