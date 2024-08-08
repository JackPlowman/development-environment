# Development Environment

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

## Visual Studio Code Extensions

To install from the extensions file, run the following command:

```bash
code --install-extension vscode-extensions
```
