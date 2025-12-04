# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    DOTFILES_PLATFORM="macos"
elif [[ -f /etc/fedora-release ]]; then
    DOTFILES_PLATFORM="linux"
else
    DOTFILES_PLATFORM="linux"
fi

# Add custom completion functions to fpath
if [[ -d ~/.zfunc ]]; then
    fpath=(~/.zfunc $fpath)
fi

# Source shared configs
source ~/.dotfiles/shared/shell/env.sh
source ~/.dotfiles/shared/shell/aliases.sh
source ~/.dotfiles/shared/shell/functions.sh

# Oh My Zsh setup (shared)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git web-search zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Source platform-specific zsh config
source ~/.dotfiles/${DOTFILES_PLATFORM}/shell/.zshrc.${DOTFILES_PLATFORM}

# Load active profile (if set)
if [[ -f ~/.dotfiles/.dotfiles-profile ]]; then
    DOTFILES_PROFILE=$(cat ~/.dotfiles/.dotfiles-profile)
    if [[ "$DOTFILES_PROFILE" != "none" && -f ~/.dotfiles/profiles/${DOTFILES_PROFILE}/.zshrc.${DOTFILES_PROFILE} ]]; then
        source ~/.dotfiles/profiles/${DOTFILES_PROFILE}/.zshrc.${DOTFILES_PROFILE}
    fi
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
