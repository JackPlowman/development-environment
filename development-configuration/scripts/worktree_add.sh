#!/bin/bash

# Add the worktree to the repository
echo "Adding the worktree to the repository..."
git worktree add -b $1 $2
