#!/bin/bash

# Reset the changes in the working directory
echo "Resetting the changes in the working directory..."
git reset --hard

# Switch to the main branch and pull the changes
echo "Switch to the main branch and pull the changes..."
git switch main && git pull origin main
