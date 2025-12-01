#!/bin/bash
# Main bashrc - sources shared, platform, and profile configs

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    DOTFILES_PLATFORM="macos"
elif [[ -f /etc/fedora-release ]]; then
    DOTFILES_PLATFORM="linux"
else
    DOTFILES_PLATFORM="linux"
fi

# Source shared configs
source ~/.dotfiles/shared/shell/env.sh
source ~/.dotfiles/shared/shell/aliases.sh
source ~/.dotfiles/shared/shell/functions.sh

# Source platform-specific bash config
source ~/.dotfiles/${DOTFILES_PLATFORM}/shell/.bashrc.${DOTFILES_PLATFORM}

# Load active profile (if set)
if [[ -f ~/.dotfiles/.dotfiles-profile ]]; then
    DOTFILES_PROFILE=$(cat ~/.dotfiles/.dotfiles-profile)
    if [[ "$DOTFILES_PROFILE" != "none" && -f ~/.dotfiles/profiles/${DOTFILES_PROFILE}/.bashrc.${DOTFILES_PROFILE} ]]; then
        source ~/.dotfiles/profiles/${DOTFILES_PROFILE}/.bashrc.${DOTFILES_PROFILE}
    fi
fi
