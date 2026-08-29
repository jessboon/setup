#!/usr/bin/env bash

set -euo pipefail

echo "Initializing MacOS engineering configuration based on Jess Boonekamps configuration."


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Apple Silicon
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  # Intel
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "✓ Homebrew already installed"
fi

# Temporarily trust existing taps
TRUSTED_TAPS=()

while IFS= read -r tap; do
  if brew trust "$tap" 2>/dev/null; then
    TRUSTED_TAPS+=("$tap")
  fi
done < <(brew tap)

# Always restore trust state when the script exits
cleanup_brew_trust() {
  echo "🔐 Restoring Homebrew tap trust state..."

  for tap in "${TRUSTED_TAPS[@]}"; do
    brew untrust "$tap" 2>/dev/null || true
  done
}

trap cleanup_brew_trust EXIT


brew update

# CLI tools
brew install \
    git \
    neovim \
    eza \
    kubectl \
    bat \
    pnpm \
    uv \
    gnupg \
    pinentry-mac

# GUI Tools
brew install --cask \
  ghostty \
  visual-studio-code \
  docker-desktop

# NVIM / NVCHAD setup
NVIM_CONFIG="$HOME/.config/nvim"
## Backup pre-existing config
if [[ -d "$NVIM_CONFIG" && ! -L "$NVIM_CONFIG" ]]; then
  BACKUP="$HOME/.config/nvim.backup.$(date +%Y%m%d%H%M%S)"
  echo "Backing up existing Neovim config → $BACKUP"
  mv "$NVIM_CONFIG" "$BACKUP"
fi

if [[ ! -d "$NVIM_CONFIG" ]]; then
  git clone https://github.com/NvChad/starter "$NVIM_CONFIG"
  rm -rf "$NVIM_CONFIG/.git"
fi
mkdir -p "$NVIM_CONFIG/lua/plugins"

# Copy existing config files
if [[ -f "$SCRIPT_DIR/nvim/lua/chadrc.lua" ]]; then
  cp "$SCRIPT_DIR/nvim/lua/chadrc.lua" \
     "$NVIM_CONFIG/lua/chadrc.lua"
else
  echo "Missing nvim/lua/chadrc.lua"
  exit 1
fi

if [[ -f "$SCRIPT_DIR/nvim/lua/plugins/theme.lua" ]]; then
  cp "$SCRIPT_DIR/nvim/lua/plugins/theme.lua" \
     "$NVIM_CONFIG/lua/plugins/theme.lua"
else
  echo "Missing nvim/lua/plugins/theme.lua"
  exit 1
fi

# Start completely clean
rm -rf "$HOME/.local/share/nvim"
rm -rf "$HOME/.local/state/nvim"
rm -rf "$HOME/.cache/nvim"

echo "NVIM x NVChad configured"

echo "Configuring Ghostty"
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"

mkdir -p "$GHOSTTY_CONFIG_DIR"
if [[ -f "$SCRIPT_DIR/ghostty/config" ]]; then
  cp "$SCRIPT_DIR/ghostty/config" \
     "$GHOSTTY_CONFIG_DIR/config"
else
  echo "Missing ghostty/config"
  exit 1
fi

# Opencode

echo "Setting up OpenCode..."

OPENCODE_CONFIG_DIR="$HOME/.config/opencode"

mkdir -p "$OPENCODE_CONFIG_DIR"

# Install OpenCode using pnpm
if ! command -v opencode >/dev/null 2>&1; then
  echo "📦 Installing OpenCode..."

  pnpm add -g opencode-ai
else
  echo "✓ OpenCode already installed"
fi

# Copy configuration
if [[ -f "$SCRIPT_DIR/opencode/opencode.json" ]]; then
  cp "$SCRIPT_DIR/opencode/opencode.json" \
     "$OPENCODE_CONFIG_DIR/opencode.json"
else
  echo "⚠️  No OpenCode config found"
  echo "    Expected: opencode/opencode.json"
fi

echo "OpenCode configured"

echo "Configuring zsh..."

ZSHRC="$HOME/.zshrc"
SOURCE_ZSHRC="$SCRIPT_DIR/zsh/.zshrc"

if [[ ! -f "$SOURCE_ZSHRC" ]]; then
  echo "Missing zsh/.zshrc"
  exit 1
fi

# Back up existing .zshrc if it isn't already ours
if [[ -f "$ZSHRC" && ! -L "$ZSHRC" ]]; then
  BACKUP="$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"

  echo "Backing up existing .zshrc → $BACKUP"
  mv "$ZSHRC" "$BACKUP"
fi

# Remove an existing symlink
if [[ -L "$ZSHRC" ]]; then
  rm "$ZSHRC"
fi

# Symlink repo config
ln -s "$SOURCE_ZSHRC" "$ZSHRC"

echo "zsh configured"
echo "  $ZSHRC → $SOURCE_ZSHRC"