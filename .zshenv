#!/bin/zsh
# Zsh environment setup (runs for all zsh shells)

# Cargo (Rust) environment
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
