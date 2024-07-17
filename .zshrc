# Path to my oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#ZSH configuration
zstyle ':omz:update' mode auto
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    poetry
    poetry-env
    thefuck
)
# Initalise Oh My ZSH
source $ZSH/oh-my-zsh.sh

# User configuration
# ------------------------------------------------------------------------#
# Program Environment Variables
## Git Custom
export GPG_TTY=$(tty)
## Homebrew JDK
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
## Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
## Add Docker
export PATH="$PATH:/usr/local/bin/docker"
## NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# ------------------------------------------------------------------------#
# Custom Environment Variables
export SSO_LOGIN_URL=https://login.apigee.com
# ------------------------------------------------------------------------#
# Tools Setup
## Oh My Posh
eval "$(oh-my-posh init zsh --config '~./development-environment/config/oh-my-posh.json')"
## The Fuck
eval $(thefuck --alias)
# ------------------------------------------------------------------------#
# Aliases
alias reload="source ~/.zshrc"
alias lg=lazygit
alias python='python3.9'

# Aliases for Development Scripts
alias commit="bash ~/development-environment/scripts/commit_and_push.sh"
alias branch_cleanup="bash ~/development-environment/scripts/remove_all_branches_except_main.sh"
alias rebase="bash ~/development-environment/scripts/rebase_and_push.sh"
alias main="bash ~/development-environment/scripts/checkout_main_and_pull.sh"
