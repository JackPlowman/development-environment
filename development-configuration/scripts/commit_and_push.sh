#!/bin/bash

# Commit the changes with the provided commit title
echo "Commiting staged changes..."
git commit -m "$1"

# # Push the changes to the remote repository
echo "Pushing changes to the remote repository..."
git push
