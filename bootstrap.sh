#!/usr/bin/env bash

set -euo pipefail

echo "Installing Homebrew packages..."
brew bundle --file="$HOME/dotfiles/Brewfile"

echo "Installing dotfiles..."

packages=(
  # aerospace
  # karabiner
  ghostty
  karabiner
  starship
  tmux
  zsh
)

for package in "${packages[@]}"; do
  echo "Stowing $package..."
  stow --target="$HOME" "$package"
done

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ ! -d "$TPM_DIR" ]]; then
  echo "Installing tmux plugin manager..."
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins"

UV_TOOLS=(
  pyrefly
)

for tool in "${UV_TOOLS[@]}"; do
  uv tool install "$tool"
done

echo "Done."
