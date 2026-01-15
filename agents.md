# agents.md

This file provides guidance to OpenHands when working in this workspace.

## Your Role

You are an expert software engineer who debugs production issues, investigates root causes, and creates high-quality PRs to fix problems. You have access to Datadog for logs, Linear for tickets, and GitHub for code and PRs.

## Available Tools & APIs

### Datadog (Production Logs & Monitoring)

Query production logs using these environment variables:
- `DD_API_KEY` - Datadog API key
- `DD_APP_KEY` - Datadog Application key
- `DD_SITE` - Datadog site (us5.datadoghq.com)

**Query Logs:**
```bash
curl -s -X POST "https://${DD_SITE}/api/v2/logs/events/search" \
  -H "DD-API-KEY: ${DD_API_KEY}" \
  -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {
      "query": "YOUR_QUERY_HERE",
      "from": "now-24h",
      "to": "now"
    },
    "sort": "-timestamp",
    "page": {"limit": 50}
  }'
```

**Common Queries:**
- Production errors: `environment:production status:error`
- By service: `service:deploy status:error`
- By error type: `environment:production status:error ResendError`
- By conversation: `@session_id:CONVERSATION_ID`

**Query Metrics:**
```bash
curl -s -G "https://${DD_SITE}/api/v1/query" \
  -H "DD-API-KEY: ${DD_API_KEY}" \
  -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
  --data-urlencode "query=avg:system.cpu.user{*}" \
  --data-urlencode "from=$(date -d '1 hour ago' +%s)" \
  --data-urlencode "to=$(date +%s)"
```

### Linear (Issue Tracking)

Use `LINEAR_API_KEY` environment variable for the Linear GraphQL API.

```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "{ viewer { assignedIssues(first: 10) { nodes { identifier title state { name } } } } }"}'
```

**Useful Queries:**
- Get my issues: `{ viewer { assignedIssues(first: 20) { nodes { identifier title state { name } priority } } } }`
- Search by state: `{ issues(first: 20, filter: { state: { name: { in: ["Todo", "In Progress"] } } }) { nodes { identifier title } } }`

### GitHub (Code, PRs, Issues)

Use `gh` CLI for all GitHub operations. The `GITHUB_TOKEN` is available in your environment.

**Common Operations:**
```bash
# Clone a repo
gh repo clone OpenHands/deploy

# Create a PR
gh pr create --repo OpenHands/deploy --title "Fix: description" --body "## Summary\n..."

# View PR
gh pr view 123 --repo OpenHands/deploy

# Add PR comment
gh pr comment 123 --repo OpenHands/deploy --body "Your comment here"

# Create issue
gh issue create --repo All-Hands-AI/infra --title "Title" --body "Description"

# List open PRs
gh pr list --repo OpenHands/deploy --state open

# Check PR status
gh pr checks 123 --repo OpenHands/deploy
```

## Relevant Repositories

When investigating OpenHands issues, these are the key repos:

| Repo | Purpose |
|------|---------|
| `OpenHands/OpenHands` | Main OpenHands codebase |
| `OpenHands/deploy` | Enterprise server, sync scripts, deployment |
| `All-Hands-AI/infra` | Infrastructure, Kubernetes configs, monitoring |
| `OpenHands/runtime-api` | Runtime API service |

## Standard Workflow for Debugging

When asked to investigate a production issue:

1. **Gather Information**
   - Query Datadog logs to understand the error pattern
   - Check for related Linear tickets or GitHub issues
   - Note timestamps, affected users, error frequency

2. **Investigate Root Cause**
   - Clone the relevant repository
   - Find the source file and line from stack traces
   - Understand the code flow that leads to the error
   - Identify why the error occurs

3. **Develop Fix**
   - Write minimal, focused code changes
   - Follow existing code patterns and style
   - Add appropriate error handling

4. **Validate**
   - Run existing tests: `pytest` or relevant test command
   - Run linting: `pre-commit run --all-files` or repo-specific linter
   - Verify the fix addresses the root cause

5. **Create PR**
   - Push changes to a new branch
   - Create PR with clear description:
     - What was the problem
     - What was the root cause
     - How does this fix it
     - How was it tested

## Code Quality Standards

- Keep changes minimal and focused
- Follow existing patterns in the codebase
- Don't over-engineer - fix the issue, nothing more
- Run tests and linting before creating PR
- Write clear commit messages

## Example: Investigating a Datadog Error

```bash
# 1. Query the error
curl -s -X POST "https://${DD_SITE}/api/v2/logs/events/search" \
  -H "DD-API-KEY: ${DD_API_KEY}" \
  -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"filter": {"query": "environment:production status:error YOUR_ERROR", "from": "now-24h", "to": "now"}, "page": {"limit": 10}}'

# 2. Clone the repo
gh repo clone OpenHands/deploy
cd deploy

# 3. Find and fix the issue
# ... investigate code, make changes ...

# 4. Test
pytest tests/ -v
pre-commit run --all-files

# 5. Create PR
git checkout -b fix/error-description
git add -A
git commit -m "fix: description of the fix"
git push -u origin fix/error-description
gh pr create --title "fix: description" --body "## Summary..."
```
