#!/bin/bash

# Reset the changes in the working directory
echo "Resetting the changes in the working directory..."
git reset --hard

# Switch to the master branch and pull the changes
echo "Switch to the master branch and pull the changes..."
git switch master && git pull origin master
