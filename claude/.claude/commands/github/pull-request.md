# Pull Request Command

## Purpose
Create comprehensive, well-documented pull requests that facilitate smooth code reviews.

## Prerequisites/Context
- Changes committed to feature branch
- Branch pushed to remote
- Tests passing locally
- **Auto-detects target branch**: PRs always go to parent (feature/* → development, development → main)
- Optional: PR number via $ARGUMENTS for updates
- Optional: Override target with `--base branch-name` flag

## Core Instructions

### 1. Determine Target Branch
```bash
# Detect current branch
CURRENT_BRANCH=$(git branch --show-current)

# Determine parent/base branch to PR against
# Check git config for the branch's upstream or merge base
BASE_BRANCH=$(git show-branch -a 2>/dev/null | grep '\*' | grep -v "$CURRENT_BRANCH" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//')

# If unable to detect, use common patterns:
# - feature/* branches -> development
# - development branch -> main
# - hotfix/* branches -> main
if [ -z "$BASE_BRANCH" ]; then
  if [[ $CURRENT_BRANCH == feature/* ]]; then
    BASE_BRANCH="development"
  elif [[ $CURRENT_BRANCH == "development" ]]; then
    BASE_BRANCH="main"
  elif [[ $CURRENT_BRANCH == hotfix/* ]]; then
    BASE_BRANCH="main"
  else
    BASE_BRANCH="main"  # fallback
  fi
fi

echo "Current branch: $CURRENT_BRANCH"
echo "Target branch for PR: $BASE_BRANCH"
```

### 2. Pre-PR Verification
```bash
# Ensure branch is up to date with target branch
git fetch origin
git rebase origin/$BASE_BRANCH

# Verify all tests pass
npm test
npm run lint
npm run typecheck

# Review complete diff
git diff $BASE_BRANCH...HEAD
```

### 3. PR Creation Process
```bash
# Push branch if not already pushed
git push -u origin $CURRENT_BRANCH

# Create PR targeting the parent branch
gh pr create --base $BASE_BRANCH \
  --title "type: clear, concise description" \
  --body "$(cat <<'EOF'
## Summary
- Bullet point overview of changes
- Key architectural decisions made
- Performance/security implications

## Changes
### Added
- New feature X with Y capability
- Tests for Z functionality

### Modified  
- Refactored A to improve B
- Updated C to support D

### Removed
- Deprecated E functionality
- Removed unused F dependency

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] Performance impact assessed

## Screenshots/Examples
[If applicable, add screenshots or usage examples]

## Related Issues
Fixes #123
Relates to #456

## Checklist
- [ ] Code follows project style guide
- [ ] Tests provide adequate coverage
- [ ] Documentation updated
- [ ] No security vulnerabilities introduced
- [ ] Backwards compatibility maintained
EOF
)"
```

### 4. PR Management
- Respond to review comments promptly
- Push fixes as new commits (don't force-push)
- Update PR description as scope changes
- Request re-review after addressing feedback

## Code Examples
```markdown
## Example PR Description
### Summary
This PR implements retry logic for database connections to address intermittent timeout issues in production.

### Changes
- Added exponential backoff retry mechanism
- Increased default timeout from 5s to 10s  
- Added connection pool health checks

### Testing
- Unit tests verify retry behavior
- Integration tests confirm connection recovery
- Load tested with 1000 concurrent connections
```

## Patterns to Follow
- **Always PR to parent branch**: feature/* → development, development → main
- Target branch is auto-detected; override with `--base` flag if needed
- Clear, descriptive titles (50 char limit)
- Comprehensive description with context
- Link related issues/PRs
- Include testing methodology
- Add reviewers familiar with code area

## Anti-Patterns/Warnings
- No "WIP" PRs without draft status
- Avoid force-pushing after reviews start
- Don't merge without required approvals
- Never bypass CI checks

## Validation Checklist
- [ ] Title clearly describes change
- [ ] Description provides full context
- [ ] All CI checks passing
- [ ] Related issues linked
- [ ] Appropriate reviewers assigned
- [ ] No merge conflicts with target branch