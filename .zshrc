# Path to my oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH configuration
zstyle ':omz:update' mode auto

# ZSH Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    poetry
    poetry-env
    thefuck
)
# Check if compinit has been called
if [[ -n ${ZSH_VERSION-} ]]; then
  if ! command -v compinit > /dev/null; then
    autoload -U +X compinit && if [[ ${ZSH_DISABLE_COMPFIX-} = true ]]; then
      compinit -u
    else
      compinit
    fi
  fi
  autoload -U +X bashcompinit && bashcompinit
fi

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
eval "$(oh-my-posh init zsh --config '~./development-configuration/config/oh-my-posh.json')"
## The Fuck
eval $(thefuck --alias)
# Zoxide
eval "$(zoxide init zsh)"
# ------------------------------------------------------------------------#
# Aliases
alias reload="source ~/.zshrc"
alias lg=lazygit
alias python='python3.9'
alias cd=z
alias cat="bat"
alias show="eza"
alias show_tree="eza -T"

# Aliases for Development Scripts
alias commit="bash ~/development-configuration/scripts/commit_and_push.sh"
alias branch_cleanup="bash ~/development-configuration/scripts/remove_all_branches_except_main.sh"
alias rebase="bash ~/development-configuration/scripts/rebase_and_push.sh"
alias main="bash ~/development-configuration/scripts/checkout_main_and_pull.sh"
