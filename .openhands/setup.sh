#\!/bin/bash
# Setup script for OpenHands workspace

# Configure gh CLI with GITHUB_PAT
if [ -n "$GITHUB_PAT" ]; then
    echo "$GITHUB_PAT" | gh auth login --with-token
    gh auth setup-git
    echo "GitHub CLI configured with GITHUB_PAT"
fi

