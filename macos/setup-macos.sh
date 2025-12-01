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
echo

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}→${NC} Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}✓${NC} Oh My Zsh installed"
else
    echo -e "${GREEN}✓${NC} Oh My Zsh already installed"
fi

# Install Powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo -e "${YELLOW}→${NC} Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    echo -e "${GREEN}✓${NC} Powerlevel10k installed"
else
    echo -e "${GREEN}✓${NC} Powerlevel10k already installed"
fi
echo

echo -e "${GREEN}✓${NC} macOS setup complete"
