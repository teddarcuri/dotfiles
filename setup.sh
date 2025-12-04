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

echo "Setting up dotfiles..."
echo

# Detect platform and run platform-specific setup
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
    echo -e "${BLUE}Detected macOS${NC}"
    echo
    source "$DOTFILES_DIR/macos/setup-macos.sh"
elif [[ -f /etc/fedora-release ]]; then
    PLATFORM="linux"
    echo -e "${BLUE}Detected Fedora Linux${NC}"
    echo
    source "$DOTFILES_DIR/linux/setup-linux.sh"
else
    PLATFORM="linux"
    echo -e "${BLUE}Detected Linux (generic)${NC}"
    echo
    source "$DOTFILES_DIR/linux/setup-linux.sh"
fi

# Profile selection
echo
echo -e "${BLUE}Profile Selection${NC}"
echo "Profiles allow work/personal separation (aliases, git identity, etc.)"
echo
echo "Available profiles:"
echo "  1) none (default - personal machine)"
echo "  2) work-sram (SRAM work environment)"
echo "  3) personal (explicit personal profile)"
echo
read -p "Select profile [1]: " profile_choice

case ${profile_choice:-1} in
    1)
        echo "none" > "$DOTFILES_DIR/.dotfiles-profile"
        echo -e "${GREEN}✓${NC} No profile activated"
        ;;
    2)
        echo "work-sram" > "$DOTFILES_DIR/.dotfiles-profile"
        ln -sf "$DOTFILES_DIR/profiles/work-sram/.gitconfig.work-sram" "$DOTFILES_DIR/.gitconfig.active-profile"
        echo -e "${GREEN}✓${NC} Activated work-sram profile"
        ;;
    3)
        echo "personal" > "$DOTFILES_DIR/.dotfiles-profile"
        ln -sf "$DOTFILES_DIR/profiles/personal/.gitconfig.personal" "$DOTFILES_DIR/.gitconfig.active-profile"
        echo -e "${GREEN}✓${NC} Activated personal profile"
        ;;
    *)
        echo -e "${YELLOW}⚠${NC} Invalid choice, defaulting to none"
        echo "none" > "$DOTFILES_DIR/.dotfiles-profile"
        ;;
esac
echo

# Shared setup tasks
echo -e "${BLUE}Setting up shared configurations...${NC}"

# Symlink root shell configs
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/.bash_profile" "$HOME/.bash_profile"
echo -e "${GREEN}✓${NC} Linked shell configs"

# Symlink zsh functions directory
ln -sf "$DOTFILES_DIR/.zfunc" "$HOME/.zfunc"
echo -e "${GREEN}✓${NC} Linked zsh functions directory"

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

# Install zsh-autosuggestions plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo -e "${YELLOW}→${NC} Installing zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    echo -e "${GREEN}✓${NC} zsh-autosuggestions installed"
else
    echo -e "${GREEN}✓${NC} zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo -e "${YELLOW}→${NC} Installing zsh-syntax-highlighting..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    echo -e "${GREEN}✓${NC} zsh-syntax-highlighting installed"
else
    echo -e "${GREEN}✓${NC} zsh-syntax-highlighting already installed"
fi

# Symlink shared configs
ln -sf "$DOTFILES_DIR/shared/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/shared/git/.gitconfig" "$HOME/.gitconfig"
echo -e "${GREEN}✓${NC} Linked tmux and git configs"

# Symlink Claude config
mkdir -p "$HOME/.claude"
ln -sf "$DOTFILES_DIR/shared/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
echo -e "${GREEN}✓${NC} Linked Claude config"

# Symlink Neovim
mkdir -p "$CONFIG_DIR"
if [ -L "$CONFIG_DIR/nvim" ] && [ "$(readlink "$CONFIG_DIR/nvim")" = "$DOTFILES_DIR/shared/nvim" ]; then
    echo -e "${GREEN}✓${NC} Neovim config already linked"
else
    [ -e "$CONFIG_DIR/nvim" ] && mv "$CONFIG_DIR/nvim" "$CONFIG_DIR/nvim.backup.$(date +%s)"
    ln -s "$DOTFILES_DIR/shared/nvim" "$CONFIG_DIR/nvim"
    echo -e "${GREEN}✓${NC} Linked Neovim config"
fi

# Symlink cross-platform app configs
apps=("ghostty" "btop" "glow")
for app in "${apps[@]}"; do
    if [ -L "$CONFIG_DIR/$app" ] && [ "$(readlink "$CONFIG_DIR/$app")" = "$DOTFILES_DIR/apps/$app" ]; then
        echo -e "${GREEN}✓${NC} $app config already linked"
    else
        [ -e "$CONFIG_DIR/$app" ] && mv "$CONFIG_DIR/$app" "$CONFIG_DIR/$app.backup.$(date +%s)"
        ln -s "$DOTFILES_DIR/apps/$app" "$CONFIG_DIR/$app"
        echo -e "${GREEN}✓${NC} Linked $app config"
    fi
done

# Install TPM (Tmux Plugin Manager) if not present
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo -e "${YELLOW}→${NC} Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    echo -e "${GREEN}✓${NC} TPM installed. Run 'prefix + I' inside tmux to install plugins"
else
    echo -e "${GREEN}✓${NC} TPM already installed"
fi

# Install Claude Code
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓${NC} Claude Code already installed ($(claude --version 2>/dev/null || echo 'unknown version'))"
else
    echo -e "${YELLOW}→${NC} Installing Claude Code CLI..."
    curl -fsSL https://claude.ai/install.sh | bash || echo -e "${YELLOW}⚠${NC} Failed to install Claude Code"
fi

echo
echo -e "${GREEN}Setup complete!${NC}"
echo
echo "Active profile: $(cat "$DOTFILES_DIR/.dotfiles-profile" 2>/dev/null || echo 'none')"
echo
echo "To switch profiles manually:"
echo "  echo 'work-sram' > ~/.dotfiles/.dotfiles-profile && source ~/.zshrc"
echo
echo "Next steps:"
echo "  - Start a new shell or run: source ~/.zshrc"
echo "  - Start tmux and press 'Ctrl+a I' to install tmux plugins"
echo "  - Configure p10k: p10k configure"
