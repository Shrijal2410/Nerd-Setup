# Git Cheat Sheet

```bash
git --version    # Display Git version
```
### Configuration

```bash
git config --global user.name "Shrijal Patel"             # Set global username
git config --global user.email "shrijal2410@gmail.com"    # Set global user email
git config --list        # List all configurations
```

### Repository Management

```bash
git init                      # Initialize a directory as a Git repository
git clone [repo-url]          # Clone a repository
git fork [repo-url]           # Fork a repository
```

## Local Changes

### Staging Changes

```bash
git add [file]    # Stage changes for commit
git reset [file]  # Unstage changes
git rm [file]     # Remove a file from staging area
git status -u     # Check status of the repository
git diff --staged # View changes in the staging area
```

### Committing Changes

```bash
git commit -m "message"    # Commit changes
```

## Remote Operations

### Push, Pull, Fetch

```bash
git push [remote] [branch]    # Push changes to remote repository
git pull [remote] [branch]    # Fetch and apply changes from remote repository
git fetch [remote]            # Fetch changes from remote repository
```

## Branching

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

## History Rewriting

### Modifying Commit History

```bash
git reset HEAD [file]              # Unstage changes for a file
git reset --hard [commit]          # Reset repository to a specific commit
git rebase -i HEAD~[commit-size]   # Rebase to modify commit history
```

### Force Changes to Remote

```bash
git push origin main --force       # Force push changes to remote repository
```

## Logging

```bash
git log --oneline --decorate --graph --all    # Display commit logs
```

## Submodules

```bash
git submodule add [repo-url] [dir]                  # Add a submodule to the repository
git submodule update --remote --init --recursive    # Update submodules recursively
```
## Additional Tips

### Reset Commit Dates

If you've inadvertently modified commit dates, perhaps due to a rebase or other operations, and you want to reset them to their original author dates, you can use the following command:

```bash
git filter-branch --env-filter "export GIT_COMMITTER_DATE=\"$GIT_AUTHOR_DATE\"" -- --all
```
This command will adjust the commit dates to match their corresponding author dates, restoring their original chronological order.

### Rebase a Commit

To rebase a commit made by another author without adding yourself as the committer, you can use the following command:

```bash
git filter-branch --commit-filter 'export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"; export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"; export GIT_COMMITTER_DATE="$GIT_AUTHOR_DATE"; git commit-tree "$@"' '<basecommit>..HEAD'
```

Replace `<basecommit>` with the actual commit hash of the commit you want to rebase from. This command ensures that the original authorship information remains intact, avoiding unintended attribution changes.