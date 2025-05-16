#!/bin/bash

# Commit the changes with the provided commit title
echo "Committing staged changes..."
git commit -m "update" --no-verify

# # Push the changes to the remote repository
echo "Pushing changes to the remote repository..."
git push
