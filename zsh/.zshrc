# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="frisk" # set by `omz`
BAT_THEME="Dracula"

# Golang Env
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Mason env
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"

plugins=(
  git
  kubectl
  history
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# User configuration
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

alias k="kubectl"
alias watch="watch -n .5"
alias g="git"
alias gitundo="git reset HEAD~1"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias mk="minikube"
alias lastcommit="git rev-parse HEAD | tr -d '\n' | pbcopy"
alias python="python3"
alias cd="z"
alias nuke="nvim"
alias n="nvim"
alias nv="NVIM_APPNAME="nvimpack" nvim ."
alias sz="source ~/.zshrc"

# IP
alias localip="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# for terminal colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export PATH="/opt/homebrew/opt/node@12/bin:$PATH"
export GIT_TERMINAL_PROMPT=1
export GOSUMDB=off
export K9S_CONFIG_DIR=~/.config/k9s

export HELM_EXPERIMENTAL_OCI=1

alias :wq="exit"
alias :q="exit"
alias :qa="exit"
alias :QA="exit"
alias qa="exit"
alias sc="silicon --from-clipboard -l bash --to-clipboard -f 'JetbrainsMono Nerd Font Mono' --window-title "

# Go
alias makedeps="go mod download && go mod tidy && go mod verify && go mod vendor"
alias findbyport="sudo lsof -i -P | grep LISTEN | grep :$PORT"

# Startship Config
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# Alias to checkout master branch and pull latest changes
alias gup='git rev-parse --is-inside-work-tree > /dev/null 2>&1 && git checkout master && git pull origin master || echo "Error: Not in a git repository or failed to checkout/pull"'

# FZF
alias nopen='nvim $(fzf -m --preview="bat --color=always {}")'
alias view='fzf -m --preview="bat --color=always {}"'

alias clearctx="kubectx -u"
alias ld="lazydocker"
alias lg="lazygit"
alias nz="nvim ~/.zshrc"
alias nw="nvim ~/.config/wezterm/wezterm.lua"

# Created by `pipx` on 2024-07-25 20:24:33
export PATH="$PATH:$HOME/.local/bin"

# check if the custom.sh file exists and source it if it does exist
if [ -f ~/.custom.sh ]; then
  source ~/.custom.sh
fi
