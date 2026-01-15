# OpenHands Workspace

A workspace configured for OpenHands to debug production issues and create PRs.

## Quick Start

1. Open this repo in OpenHands GUI
2. Make sure these env vars are set:
   - `DD_API_KEY`, `DD_APP_KEY`, `DD_SITE`
   - `LINEAR_API_KEY`
   - `GITHUB_PAT`
3. Ask OpenHands to investigate an issue

## Example Prompt

```
I am seeing ResendError rate limiting errors in Datadog production logs.
Please investigate the root cause and create a PR to fix it.
```

## Files

- `agents.md` - Instructions for OpenHands
- `.openhands/setup.sh` - Configures gh CLI with GITHUB_PAT

