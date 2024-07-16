# Development Environment

## Getting Started

Run the following commands to install the development environment:

```bash
git clone https://github.com/JackPlowman/development-environment.git
cd development-environment
```

Copy the `.zshrc` file to your home directory:

```bash
cp -i .zshrc ~/.zshrc
```

Open the `.zshrc` file in your text editor and make any necessary changes.

## Usage

To start a new terminal session, open the terminal and run the following command:

```bash
source ~/.zshrc
```

This will load the development environment and set up the necessary aliases and environment variables.

## Development

To update the ZSH configuration when making changes, run the following command:

```bash
scripts/dev.zsh
```

This will reload the configuration and apply any changes.

