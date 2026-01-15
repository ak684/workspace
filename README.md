# OpenHands Workspace

This repository is configured for OpenHands to debug production issues and create PRs.

## How to Use

1. Open this repo in OpenHands GUI
2. Give OpenHands a task like:
   - "I am seeing ResendError rate limiting errors in Datadog. Please investigate and create a PR to fix it."
   - "Check Linear for my assigned issues and investigate the highest priority one"

## What OpenHands Can Do

- **Query Datadog** for production logs and errors
- **Query Linear** for issue tracking
- **Clone repos** like OpenHands/deploy, OpenHands/OpenHands
- **Create PRs** with fixes
- **Run tests and linting** to validate changes

## Required Environment Variables

Make sure these are set in your OpenHands environment:
- `DD_API_KEY` - Datadog API key
- `DD_APP_KEY` - Datadog Application key  
- `DD_SITE` - Datadog site (us5.datadoghq.com)
- `LINEAR_API_KEY` - Linear API key
- `GITHUB_TOKEN` - GitHub token for PR operations

## See agents.md for full instructions

