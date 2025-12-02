#!/usr/bin/env bash
# Linux-specific setup script

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up Linux-specific configurations...${NC}"
echo

# Enable COPR repositories (Fedora only)
if [[ -f /etc/fedora-release ]] && [[ -f "$DOTFILES_DIR/linux/copr.repos" ]]; then
    echo -e "${BLUE}Enabling COPR repositories...${NC}"
    while IFS= read -r repo || [[ -n "$repo" ]]; do
        # Skip comments and empty lines
        [[ "$repo" =~ ^#.*$ ]] && continue
        [[ -z "$repo" ]] && continue

        # Check if repo is already enabled
        if dnf copr list 2>/dev/null | grep -q "$repo"; then
            echo -e "${GREEN}✓${NC} COPR $repo already enabled"
        else
            echo -e "${YELLOW}→${NC} Enabling COPR $repo..."
            sudo dnf copr enable -y "$repo" || echo -e "${YELLOW}⚠${NC} Failed to enable COPR $repo"
        fi
    done < "$DOTFILES_DIR/linux/copr.repos"
    echo
fi

# Install packages (Fedora)
if [[ -f /etc/fedora-release ]] && [[ -f "$DOTFILES_DIR/linux/packages.dnf" ]]; then
    echo -e "${YELLOW}→${NC} Installing packages from packages.dnf..."
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
            sudo dnf install -y "$package" || echo -e "${YELLOW}⚠${NC} Failed to install $package"
        fi
    done < "$DOTFILES_DIR/linux/packages.dnf"
    echo
fi

# Symlink Niri config (Wayland)
if command -v niri &> /dev/null; then
    mkdir -p "$CONFIG_DIR"
    if [ -L "$CONFIG_DIR/niri" ] && [ "$(readlink "$CONFIG_DIR/niri")" = "$DOTFILES_DIR/linux/apps/niri" ]; then
        echo -e "${GREEN}✓${NC} Niri config already linked"
    else
        [ -e "$CONFIG_DIR/niri" ] && mv "$CONFIG_DIR/niri" "$CONFIG_DIR/niri.backup.$(date +%s)"
        ln -s "$DOTFILES_DIR/linux/apps/niri" "$CONFIG_DIR/niri"
        echo -e "${GREEN}✓${NC} Linked Niri config"
    fi
fi

# Symlink Waybar config (Wayland)
if command -v waybar &> /dev/null; then
    mkdir -p "$CONFIG_DIR"
    if [ -L "$CONFIG_DIR/waybar" ] && [ "$(readlink "$CONFIG_DIR/waybar")" = "$DOTFILES_DIR/linux/apps/waybar" ]; then
        echo -e "${GREEN}✓${NC} Waybar config already linked"
    else
        [ -e "$CONFIG_DIR/waybar" ] && mv "$CONFIG_DIR/waybar" "$CONFIG_DIR/waybar.backup.$(date +%s)"
        ln -s "$DOTFILES_DIR/linux/apps/waybar" "$CONFIG_DIR/waybar"
        echo -e "${GREEN}✓${NC} Linked Waybar config"
    fi
fi

# Symlink Mako config (Wayland notification daemon)
if command -v mako &> /dev/null; then
    mkdir -p "$CONFIG_DIR"
    if [ -L "$CONFIG_DIR/mako" ] && [ "$(readlink "$CONFIG_DIR/mako")" = "$DOTFILES_DIR/linux/apps/mako" ]; then
        echo -e "${GREEN}✓${NC} Mako config already linked"
    else
        [ -e "$CONFIG_DIR/mako" ] && mv "$CONFIG_DIR/mako" "$CONFIG_DIR/mako.backup.$(date +%s)"
        ln -s "$DOTFILES_DIR/linux/apps/mako" "$CONFIG_DIR/mako"
        echo -e "${GREEN}✓${NC} Linked Mako config"
    fi
fi

# Symlink Rofi config (Wayland app launcher)
if command -v rofi &> /dev/null; then
    mkdir -p "$CONFIG_DIR"
    if [ -L "$CONFIG_DIR/rofi" ] && [ "$(readlink "$CONFIG_DIR/rofi")" = "$DOTFILES_DIR/linux/apps/rofi" ]; then
        echo -e "${GREEN}✓${NC} Rofi config already linked"
    else
        [ -e "$CONFIG_DIR/rofi" ] && mv "$CONFIG_DIR/rofi" "$CONFIG_DIR/rofi.backup.$(date +%s)"
        ln -s "$DOTFILES_DIR/linux/apps/rofi" "$CONFIG_DIR/rofi"
        echo -e "${GREEN}✓${NC} Linked Rofi config"
    fi
fi

echo -e "${GREEN}✓${NC} Linux setup complete"
