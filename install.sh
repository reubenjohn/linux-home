#!/bin/sh

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Symlink the .zshrc file to the home directory
ln -sf "$SCRIPT_DIR/.zshrc" ~/.zshrc

echo "Installation complete. Zsh configuration reloaded."
echo "To to reload the configuration, run:"
echo "source ~/.zshrc"