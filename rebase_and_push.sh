#!/bin/bash

# Git Fetch
echo "Fetching the latest changes from the remote repository..."
git fetch

# Get the branch name from the command line argument
branch="${1:-origin/main}"

# Rebase current branch with the specified branch
echo "Rebasing the current branch with the specified branch..."
git rebase $branch

# Push the changes to the remote repository
echo "Pushing the changes to the remote repository..."
git push --force-with-lease
