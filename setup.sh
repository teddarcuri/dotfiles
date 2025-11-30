#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/fedora-release ]]; then
        echo "fedora"
    elif [[ -f /etc/os-release ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)

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

# Enable COPR repositories
enable_copr_repos() {
    if [[ "$OS" == "fedora" ]]; then
        if [[ -f "$DOTFILES_DIR/copr.repos" ]]; then
            echo -e "${BLUE}Enabling COPR repositories...${NC}"
            while IFS= read -r repo || [[ -n "$repo" ]]; do
                # Skip comments and empty lines
                [[ "$repo" =~ ^#.*$ ]] && continue
                [[ -z "$repo" ]] && continue

                # Check if repo is already enabled
                if dnf copr list | grep -q "$repo"; then
                    echo -e "${GREEN}✓${NC} COPR $repo already enabled"
                else
                    echo -e "${YELLOW}→${NC} Enabling COPR $repo..."
                    sudo dnf copr enable -y "$repo" || echo -e "${YELLOW}⚠${NC} Failed to enable COPR $repo"
                fi
            done < "$DOTFILES_DIR/copr.repos"
            echo
        fi
    fi
}

# Install packages
install_packages() {
    echo -e "${BLUE}Installing packages...${NC}"

    if [[ "$OS" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            echo -e "${RED}Homebrew not found. Please install it first:${NC}"
            echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            return 1
        fi

        if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
            echo -e "${YELLOW}→${NC} Installing from Brewfile..."
            brew bundle --file="$DOTFILES_DIR/Brewfile"
        fi

    elif [[ "$OS" == "fedora" ]]; then
        if [[ -f "$DOTFILES_DIR/packages.dnf" ]]; then
            echo -e "${YELLOW}→${NC} Installing from packages.dnf..."
            while IFS= read -r line || [[ -n "$line" ]]; do
                # Skip comments and empty lines
                [[ "$line" =~ ^#.*$ ]] && continue
                [[ -z "$line" ]] && continue

                # Extract package name (strip inline comments)
                package=$(echo "$line" | awk '{print $1}')

                if rpm -q "$package" &> /dev/null; then
                    echo -e "${GREEN}✓${NC} $package already installed"
                else
                    echo -e "${YELLOW}→${NC} Installing $package..."
                    sudo dnf install -y "$package" || echo -e "${YELLOW}⚠${NC} Failed to install $package (may not be in repos)"
                fi
            done < "$DOTFILES_DIR/packages.dnf"
        fi
    else
        echo -e "${YELLOW}⚠${NC} Unknown OS, skipping package installation"
    fi

    echo
}

# Run setup steps in order
enable_copr_repos
install_packages

# Ghostty
echo "Setting up Ghostty config..."
copy_to_dotfiles "$CONFIG_DIR/ghostty" "$DOTFILES_DIR/ghostty"
create_symlink "$DOTFILES_DIR/ghostty" "$CONFIG_DIR/ghostty"
echo

# Niri
echo "Setting up Niri config..."
copy_to_dotfiles "$CONFIG_DIR/niri" "$DOTFILES_DIR/niri"
create_symlink "$DOTFILES_DIR/niri" "$CONFIG_DIR/niri"
echo

echo -e "${GREEN}Done!${NC} Your dotfiles are now set up."
echo "Edit configs in $DOTFILES_DIR and they will be reflected in your system."
