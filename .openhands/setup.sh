#\!/bin/bash
# Setup script for OpenHands workspace

# Install jq if not present
if \! command -v jq &> /dev/null; then
    apt-get update && apt-get install -y jq
    echo "jq installed"
fi

# Configure gh CLI with GITHUB_PAT
if [ -n "$GITHUB_PAT" ]; then
    echo "$GITHUB_PAT" | gh auth login --with-token
    gh auth setup-git
    echo "GitHub CLI configured with GITHUB_PAT"
fi

