# GitHub Cheat Sheet

## Basic Commands

```bash
git --version    # Display Git version
```

## Setup

### Configuration

```bash
git config --global user.name "Shrijal Patel"             # Set global username
git config --global user.email "shrijal2410@gmail.com"    # Set global user email
git config --list        # List all configurations
```

### Initialize, Clone, and Fork

```bash
git init                      # Initialize dir as a git repo
git branch -M main            # Rename default branch to 'main'
git remote add origin [url]   # Add remote repo URL

git clone [repo-url]          # Clone a repo
git fork [repo-url]           # Fork a repo
```

## Local Changes

### Adding and Viewing Changes

```bash
git add [file]    # Stage changes for commit
git reset [file]  # Unstage changes
git rm [file]     # Remove a file from git and staging area

git status -u     # Status of the git
git diff --staged # Changes in the staged area
```

### Committing Changes

```bash
git commit -m "message"    # Commit changes
```

### Pushing, Pulling, and Fetching

```bash
git push [remote] [branch]    # Push changes to remote repo
git pull [remote] [branch]    # Fetch and add changes from remote repo
git fetch [remote]            # Fetch changes from remote repo
```

## Branch & Merge

### Managing Branches

```bash
git branch                    # List all branches
git branch [branch-name]      # Create a new branch
git checkout [branch-name]    # Switch to a different branch
git branch -d [branch-name]   # Delete a branch
```

### Merging Changes

```bash
git merge [branch-name]       # Merge changes from a branch into the current one
```

## Rewrite History

### Modifying Commit History

```bash
git reset HEAD [file]              # Unstage changes for a file
git reset --hard [commit]          # Reset repo to a specific commit

git rebase -i HEAD~[commit-size]   # Rebase to modify commit history
```

### Forcing Changes to GitHub

```bash
git push origin main --force       # Force push changes to GitHub
```

## Miscellaneous

### Logging

```bash
git log --oneline --decorate --graph --all    # Display commit logs
```

### Submodules

```bash
git submodule add [repo-url] [dir]                  # Add a submodule to the repo
git submodule update --remote --init --recursive    # Update submodules recursively
```