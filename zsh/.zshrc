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
  alias-finder
)
source $ZSH/oh-my-zsh.sh

# User configuration
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias k="kubectl"
alias watch="watch -n .5"
alias g="git"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias mk="minikube"
alias python="python3"
alias cd="z"
alias nuke="nvim"
alias nuk="nvim"
alias nnn="nvim"

# tmux alpases
alias tn="tmux new -s"
alias ta="tmux attach -t"
alias tl="tmux ls"
alias td="tmux detach"
alias tk="tmux kill-session -t"
alias tka="tmux kill-session -a"
alias tks="tmux kill-session -a"
# alias tnew to create a new tmux session with the name ing (short for ING) only if it doesn't exist already, if it exists, it will attach to the existing session
alias sn="tmux new -s ing || tmux attach -t ing"

# IP
alias localip="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# for terminal colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export PATH="/opt/homebrew/opt/node@12/bin:$PATH"
export GIT_TERMINAL_PROMPT=1
export GOSUMDB=off
export K9S_CONFIG_DIR=~/.config/k9s

# go Project commands
alias golint="go vet ./..."
alias gotest="go test --count=1 -coverprofile=coverage.out ./pkg/..."

export HELM_EXPERIMENTAL_OCI=1

alias keyRepeatOn="defaults write -g ApplePressAndHoldEnabled -bool false"
alias keyRepeatOff="defaults write -g ApplePressAndHoldEnabled -bool true"
alias startupSoundOff="sudo nvram StartupMute=%01"
alias startupSoundOn="sudo nvram StartupMute=%00"
alias :wq="exit"
alias :q="exit"
alias :qa="exit"
alias :QA="exit"
alias qa="exit"
alias sc="silicon --from-clipboard -l bash --to-clipboard -f 'JetbrainsMono Nerd Font Mono' --window-title "

# Kubernetes Autocompletions
autoload -Uz compinit
compinit
source <(kubectl completion zsh)

# Go
alias makedeps="go mod download && go mod tidy && go mod verify && go mod vendor"
alias findbyport="sudo lsof -i -P | grep LISTEN | grep :$PORT"

# Startship Config
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
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
alias nw="nvim ~/.wezterm.lua"

# Created by `pipx` on 2024-07-25 20:24:33
export PATH="$PATH:$HOME/.local/bin"

# check if the custom.sh file exists and source it if it does exist
if [ -f ~/.custom.sh ]; then
  source ~/.custom.sh
fi

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# yazi configuration
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
