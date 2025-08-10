# 🚀 Git CLI Quick Reference for VybeMVP

## 📋 Setup Complete ✅

- **Git Version:** 2.50.1 (latest via Homebrew)
- **SSH Key:** ed25519 generated and added to keychain
- **Repository:** SSH authentication configured
- **Remote:** `git@github.com:chakrazulu/VybeMVP.git`

## 🔑 Next Step: Add SSH Key to GitHub

Your SSH public key has been copied to clipboard. Add it to GitHub:

1. Go to https://github.com/settings/ssh/new
2. Title: `VybeMVP macOS Development`
3. Paste the key (already in clipboard)
4. Click "Add SSH key"

## 🛠 Essential Git CLI Commands

### Daily Workflow
```bash
# Check status (like a health dashboard)
git status

# See what changed
git diff

# Stage specific files
git add path/to/file.swift
git add .  # Stage everything

# Commit with message
git commit -m "feat: Add new feature"

# Push to remote
git push origin branch-name
```

### Branch Management
```bash
# List branches
git branch -a

# Create new branch
git checkout -b feature/new-feature

# Switch branches
git checkout branch-name
git switch branch-name  # Modern alternative

# Delete branch
git branch -d branch-name
```

### Synchronization
```bash
# Fetch latest from remote
git fetch origin

# Pull latest changes
git pull origin main

# Push current branch
git push
git push -u origin branch-name  # First push sets upstream
```

### History & Information
```bash
# View commit history
git log --oneline
git log --graph --oneline --all

# See file changes in commit
git show commit-hash

# Compare branches
git diff main..feature-branch
```

### Automation Integration
```bash
# Run your existing make targets
make content-all
make content-lint
make content-normalize
make content-export

# Test before commit
make test  # If you have this target
# or
cmd+U  # In Xcode
```

## 🔥 Power User Commands

### Interactive Staging
```bash
git add -p  # Stage chunks interactively
```

### Stashing (Save work temporarily)
```bash
git stash  # Save current work
git stash pop  # Restore saved work
git stash list  # See all stashes
```

### Reset & Undo
```bash
git reset HEAD~1  # Undo last commit (keep changes)
git reset --hard HEAD~1  # Undo last commit (lose changes)
git checkout -- file.swift  # Discard file changes
```

### Remote Management
```bash
git remote -v  # See remote URLs
git remote add upstream https://github.com/original/repo.git  # Add upstream
```

## 🚦 VybeMVP Specific Workflow

```bash
# 1. Start new feature
git checkout main
git pull origin main
git checkout -b feature/awesome-new-thing

# 2. Make changes, then...
git add .
git commit -m "feat: Add awesome new thing"

# 3. Run your pipeline
make content-all  # Your bulletproof content pipeline

# 4. Push and create PR
git push -u origin feature/awesome-new-thing
# Then create PR on GitHub

# 5. After PR merged
git checkout main
git pull origin main
git branch -d feature/awesome-new-thing
```

## 🛡 Security Notes

- **SSH Key:** ed25519 (modern, secure)
- **Keychain:** Automatically managed by macOS
- **No Passwords:** SSH eliminates password prompts
- **Key Location:** `~/.ssh/id_ed25519`

## 🎯 Testing SSH Connection

After adding key to GitHub, test with:
```bash
ssh -T git@github.com
```

Should show: "Hi chakrazulu! You've successfully authenticated..."

## 📱 Integration with Existing Tools

Your existing workflow remains intact:
- **Xcode:** Still use Cmd+U for tests
- **Make targets:** All still work
- **Pre-commit hooks:** Will run automatically
- **CI/CD:** GitHub Actions unchanged

Git CLI gives you the "universal remote" - direct control over your spiritual AI infrastructure!

---
*Generated: August 10, 2025 - Git CLI Setup Complete*
