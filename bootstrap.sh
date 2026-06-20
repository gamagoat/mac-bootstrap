#!/bin/bash
set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORMULAE_FILE="${SCRIPT_DIR}/formulae.txt"
CASK_FILE="${SCRIPT_DIR}/casks.txt"
ZSHRC_FILE="${SCRIPT_DIR}/.zshrc"

echo "Installing Homebrew packages..."

# Install formulae
if [[ -f "$FORMULAE_FILE" ]]; then
    while IFS= read -r formula; do
        # Skip empty lines and comments
        [[ -z "$formula" || "$formula" =~ ^# ]] && continue

        if brew list --formula "$formula" &>/dev/null; then
            echo "  ✓ $formula (already installed)"
        else
            echo "  → Installing $formula..."
            brew install "$formula"
        fi
    done < "$FORMULAE_FILE"
else
    echo "Error: $FORMULAE_FILE not found" >&2
    exit 1
fi

echo "Installing Homebrew casks..."

# Install casks
if [[ -f "$CASK_FILE" ]]; then
    while IFS= read -r cask; do
        # Skip empty lines and comments
        [[ -z "$cask" || "$cask" =~ ^# ]] && continue

        if brew list --cask "$cask" &>/dev/null; then
            echo "  ✓ $cask (already installed)"
        else
            echo "  → Installing $cask..."
            brew install --cask "$cask"
        fi
    done < "$CASK_FILE"
else
    echo "Error: $CASK_FILE not found" >&2
    exit 1
fi

echo "Configuring shell..."

# Copy .zshrc to home directory
if [[ -f "$ZSHRC_FILE" ]]; then
    cp "$ZSHRC_FILE" ~/.zshrc
    echo "  ✓ .zshrc configured"
else
    echo "Error: $ZSHRC_FILE not found" >&2
    exit 1
fi

echo "Bootstrap complete!"
