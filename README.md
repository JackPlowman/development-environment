# Development Environment

This repository contains my development environment configuration files, including dotfiles for Zsh, and other tools. It is designed to be used with GNU Stow to manage the symlinks in your home directory.

## Getting Started

Run the following commands to install the development environment:

```bash
git clone https://github.com/JackPlowman/development-environment.git
cd development-environment
```

Stow the dotfiles in your home directory:

```bash
stow -t ~/ -R .
```

Open the `.zshrc` file in your text editor and make any necessary changes.

Then start a new terminal session, open the terminal and run the following command:

```bash
source ~/.zshrc
```

## Homebrew

### Create brewfile

To create a brewfile, run the following command:

```bash
brew bundle dump
```

### Install from brewfile

To install from the brewfile, run the following command:

```bash
brew bundle install
```
