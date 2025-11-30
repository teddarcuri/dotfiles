#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"

    # If target already exists and is a symlink pointing to source, skip
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo -e "${GREEN}✓${NC} $target already linked correctly"
        return 0
    fi

    # If target exists (file or directory), back it up
    if [ -e "$target" ] || [ -L "$target" ]; then
        backup="${target}.backup.$(date +%s)"
        echo -e "${YELLOW}→${NC} Backing up existing $target to $backup"
        mv "$target" "$backup"
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"

    # Create symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}✓${NC} Linked $target → $source"
}

# Function to copy config to dotfiles if not already there
copy_to_dotfiles() {
    local config_path="$1"
    local dotfiles_path="$2"

    if [ ! -e "$dotfiles_path" ] && [ -e "$config_path" ]; then
        echo -e "${YELLOW}→${NC} Copying $config_path to dotfiles"
        mkdir -p "$(dirname "$dotfiles_path")"
        cp -r "$config_path" "$dotfiles_path"
        echo -e "${GREEN}✓${NC} Copied to dotfiles"
    elif [ -e "$dotfiles_path" ]; then
        echo -e "${GREEN}✓${NC} Config already exists in dotfiles"
    fi
}

echo "Setting up dotfiles..."
echo

# Ghostty
echo "Setting up Ghostty config..."
copy_to_dotfiles "$CONFIG_DIR/ghostty" "$DOTFILES_DIR/ghostty"
create_symlink "$DOTFILES_DIR/ghostty" "$CONFIG_DIR/ghostty"
echo

echo -e "${GREEN}Done!${NC} Your dotfiles are now set up."
echo "Edit configs in $DOTFILES_DIR and they will be reflected in your system."
