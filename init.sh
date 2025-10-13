#!/bin/bash
# ~/dotfiles/init.sh
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "======================================"
echo "  Dev Environment Setup"
echo "======================================"

# Check if mutagen is installed
if ! command -v mutagen &> /dev/null; then
    echo ""
    echo "→ Installing Mutagen..."
    
    # Download latest binary
    MUTAGEN_VERSION=$(curl -s https://api.github.com/repos/mutagen-io/mutagen/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
    curl -L "https://github.com/mutagen-io/mutagen/releases/download/v${MUTAGEN_VERSION}/mutagen_linux_amd64_v${MUTAGEN_VERSION}.tar.gz" -o /tmp/mutagen.tar.gz
    tar -xzf /tmp/mutagen.tar.gz -C /tmp mutagen
    mkdir -p ~/.local/bin
    mv /tmp/mutagen ~/.local/bin/
    chmod +x ~/.local/bin/mutagen
    rm /tmp/mutagen.tar.gz
    
    echo "✓ Mutagen installed"
fi

# Git configuration
echo ""
echo "→ Checking git configuration..."
if ! git config --global user.name > /dev/null 2>&1; then
    read -p "Enter your name: " git_name
    read -p "Enter your email: " git_email
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    echo "✓ Git configured"
else
    echo "✓ Git already configured as: $(git config --global user.name)"
fi

# Initial sync (copy dotfiles to home before setting up mutagen)
echo ""
echo "→ Initial dotfiles sync..."
cp -f "$DOTFILES_DIR/shell/.bashrc" ~/.bashrc 2>/dev/null || true
cp -f "$DOTFILES_DIR/shell/.zshrc" ~/.zshrc 2>/dev/null || true
mkdir -p ~/.config/nvim && cp -rf "$DOTFILES_DIR/nvim/"* ~/.config/nvim/ 2>/dev/null || true
mkdir -p ~/.config/helix && cp -rf "$DOTFILES_DIR/helix/"* ~/.config/helix/ 2>/dev/null || true
echo "✓ Initial files copied"

# Setup Mutagen sync sessions
echo ""
echo "→ Setting up Mutagen sync sessions..."
"$DOTFILES_DIR/setup-mutagen-sync.sh"

# Language runtimes
echo ""
echo "→ Installing language runtimes..."
read -p "Install languages? (1=Essential, 2=All, 3=Skip) [1]: " lang_choice
lang_choice=${lang_choice:-1}

case $lang_choice in
    1)
        echo "Installing essential languages..."
        mise use --global node@lts
        mise use --global rust@stable
        mise use --global go@latest
        ;;
    2)
        echo "Installing all languages..."
        mise use --global node@lts
        mise use --global rust@stable
        mise use --global go@latest
        mise use --global deno@latest
        mise use --global bun@latest
        ;;
    3)
        echo "Skipping language installation"
        ;;
esac

# Doom Emacs
echo ""
read -p "Install Doom Emacs? (y/N): " install_doom
if [[ "$install_doom" =~ ^[Yy]$ ]]; then
    if [[ ! -d ~/.config/emacs ]]; then
        git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
        ~/.config/emacs/bin/doom install
        mkdir -p ~/.config/doom
        cp -rf "$DOTFILES_DIR/doom/"* ~/.config/doom/ 2>/dev/null || true
        echo 'export PATH="$HOME/.config/emacs/bin:$PATH"' >> ~/.bashrc
        echo "✓ Doom Emacs installed"
    else
        echo "✓ Doom already installed"
    fi
fi

touch ~/.setup-complete

echo ""
echo "======================================"
echo "  Setup Complete!"
echo "======================================"
echo ""
echo "✓ Mutagen is syncing your dotfiles in real-time!"
echo ""
echo "Installed runtimes:"
mise list 2>/dev/null || echo "  (none)"
echo ""
echo "Mutagen commands:"
echo "  mutagen sync list      - View sync sessions"
echo "  mutagen sync monitor   - Watch syncs in real-time"
echo "  dots-status           - Alias for list"
echo "  dots-monitor          - Alias for monitor"
echo ""
echo "Next steps:"
echo "  1. source ~/.bashrc"
echo "  2. doom sync (if installed)"
echo "  3. Edit any config - it syncs automatically!"
echo ""
