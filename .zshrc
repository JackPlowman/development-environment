# Path to my oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH configuration
zstyle ':omz:update' mode auto

# ZSH Plugins
plugins=(
  aws
  terraform
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  poetry
  poetry-env
  thefuck
)
# Check if compinit has been called
if [[ -n ${ZSH_VERSION-} ]]; then
  if ! command -v compinit >/dev/null; then
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
# Remove aws_prompt_info from right = https://github.com/ohmyzsh/ohmyzsh/discussions/10726
RPROMPT="${RPROMPT//\$\(aws_prompt_info\)/}"
# User configuration
# ------------------------------------------------------------------------#
# Program Environment Variables/PATH updates
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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
## Go (Golang)
export PATH="$PATH:$HOME/go/bin"
export GOPATH="$HOME/Projects/Personal"
# Java
export JAVA_HOME="/opt/homebrew/opt/openjdk"
export PATH="$JAVA_HOME/bin:$PATH"
# ------------------------------------------------------------------------#
# Custom Environment Variables
export SSO_LOGIN_URL=https://login.apigee.com
# ------------------------------------------------------------------------#
# Tools Setup
## Oh My Posh
eval "$(oh-my-posh init zsh --config '~/development-configuration/config/oh-my-posh.json')"
## The Fuck
eval $(thefuck --alias)
# Zoxide
eval "$(zoxide init zsh)"
# Fzf Completions
source <(fzf --zsh)
# Eza Completions
export FPATH="/opt/homebrew/bin/eza/completions/zsh:$FPATH"
# Set manpath
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Set up Terraform Completions
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
# Set up Git/FZF completions
source ~/development-configuration/zsh-other-files/fzf-git-shortcuts.zsh
# Set up Graphite Completions
source ~/development-configuration/zsh-other-files/graphite-completions.zsh
# Set up Oh My Posh Completions
source ~/development-configuration/zsh-other-files/oh-my-posh-completions.zsh
# ------------------------------------------------------------------------#
# Aliases
alias reload="source ~/.zshrc"
alias lg=lazygit
alias python='python3.9'
alias cd=z
alias cat="bat"
alias show="eza"
alias show_tree="eza -T"
alias ls="eza"
alias branch="_fzf_git_each_ref --no-multi | xargs git checkout"
alias checkout='function _checkout() { git branch | fzf -q "$1" | xargs git checkout; }; _checkout'
alias pretty="prettier . --check --write"
alias commands="bat ~/development-configuration/commands.md"
# Aliases for Development Scripts
alias commit="bash ~/development-configuration/scripts/commit_and_push.sh"
alias update="bash ~/development-configuration/scripts/update_and_push.sh"
alias branch_cleanup="bash ~/development-configuration/scripts/remove_all_branches_except_default.sh"
alias rebase="bash ~/development-configuration/scripts/rebase_and_push.sh"
alias main="bash ~/development-configuration/scripts/checkout_main_and_pull.sh"
alias master="bash ~/development-configuration/scripts/checkout_master_and_pull.sh"

. "$HOME/.local/bin/env"
