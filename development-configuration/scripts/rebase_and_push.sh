#!/bin/bash

# Git Fetch
echo "Fetching the latest changes from the remote repository..."
git fetch

# Get default branch name
default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

# Get the branch name from the command line argument
branch="${1:-origin/$default_branch}"

# Rebase current branch with the specified branch
echo "Rebasing the current branch with the specified branch..."
git rebase "$branch"

# Push the changes to the remote repository
echo "Pushing the changes to the remote repository..."
git push --force-with-lease
