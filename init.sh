#!/bin/bash
set -euo pipefail

REPO_PATH="${HOME}/repos/mac-bootstrap"
REPO_URL="https://github.com/smalls/mac-bootstrap.git"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Starting macOS bootstrap..."

# Install Homebrew if needed
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed"
fi

# Ensure Homebrew is in PATH for this session (Apple Silicon)
export PATH="/opt/homebrew/bin:$PATH"

# Install git if needed
if ! command -v git &>/dev/null; then
    echo "Installing git..."
    brew install git
else
    echo "Git already installed"
fi

# Clone or update repository
if [[ -d "$REPO_PATH" ]]; then
    echo "Repository exists, pulling latest..."
    (
        cd "$REPO_PATH"
        git pull || { echo "Error: git pull failed" >&2; exit 1; }
    )
else
    echo "Cloning repository..."
    mkdir -p "$(dirname "$REPO_PATH")"
    git clone "$REPO_URL" "$REPO_PATH"
fi

# Run the main bootstrap script
echo "Running bootstrap..."
(
    cd "$REPO_PATH"
    bash bootstrap.sh || { echo "Error: bootstrap failed" >&2; exit 1; }
)

echo -e "${GREEN}Bootstrap complete!${NC}"
