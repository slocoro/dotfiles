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

echo "Done."
