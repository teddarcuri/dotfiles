#!/usr/bin/env bash
# macOS-specific setup script

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up macOS-specific configurations...${NC}"
echo

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${RED}Homebrew not found. Please install it first:${NC}"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Install packages from Brewfile
if [[ -f "$DOTFILES_DIR/macos/Brewfile" ]]; then
    echo -e "${YELLOW}→${NC} Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/macos/Brewfile"
    echo -e "${GREEN}✓${NC} Homebrew packages installed"
else
    echo -e "${YELLOW}⚠${NC} No Brewfile found, skipping package installation"
fi

echo -e "${GREEN}✓${NC} macOS setup complete"
