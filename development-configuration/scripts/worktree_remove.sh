#!/bin/bash

# Remove the worktree from the repository
echo "Removing the worktree from the repository..."
git worktree remove $1
