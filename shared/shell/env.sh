#!/bin/bash
# Shared environment variables for all platforms

# Set nvim as default editor
export EDITOR=nvim
export VISUAL=nvim

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Cargo (Rust)
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# direnv
if command -v direnv &> /dev/null; then
    eval "$(direnv hook bash)" 2>/dev/null || eval "$(direnv hook zsh)" 2>/dev/null
fi
