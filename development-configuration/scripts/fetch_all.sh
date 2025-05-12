#!/bin/bash

# Define the path to your projects folder
PROJECTS_DIR="$HOME/Projects/Personal"

# Check if the directory exists
if [ ! -d "$PROJECTS_DIR" ]; then
  echo "Error: Directory $PROJECTS_DIR does not exist."
  exit 1
fi

# Iterate through all subdirectories in the projects folder
for dir in "$PROJECTS_DIR"/*; do
  if [ -d "$dir/.git" ]; then
    echo "Fetching updates for repository: $dir"
    # Navigate to the repository and fetch updates
    (cd "$dir" && git fetch)
  else
    echo "Skipping: $dir is not a git repository."
  fi
done

echo "Fetch operation completed for all repositories."
