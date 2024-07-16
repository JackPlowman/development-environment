#!/bin/zsh

# Get the current date and time
dt=$(date '+%d-%m-%Y_%H-%M-%S')
echo Date time is: $dt
# Make a backup of the original .zshrc file
mkdir -p ~/zshrc_temp
cp ~/.zshrc ~/zshrc_temp/${dt}_original.zshrc

# Copy the new .zshrc file to the original location
cp .zshrc ~/.zshrc

# Reload the .zshrc file
source ~/.zshrc
