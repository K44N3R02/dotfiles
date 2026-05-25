if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set PATH
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# Java Version Switching
export JAVA_8_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA_25_HOME=$(/usr/libexec/java_home -v 25)

alias java8='export JAVA_HOME=$JAVA_8_HOME; java'
alias java25='export JAVA_HOME=$JAVA_25_HOME; java'

# Set a default version (Optional - e.g., keep 25 as default)
export JAVA_HOME=$JAVA_25_HOME

# Set default editor
export EDITOR='nvim'

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it doesn't already exist
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in the Big Three
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Other plugins
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q

# Load edit line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

if [ $TERM_PROGRAM != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/minimal.toml)"
fi

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Set cursor
echo -e "\033[1 q"

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# fzf rosepine theme
export FZF_DEFAULT_OPTS="
     --color=fg:#908caa,hl:#ea9a97
     --color=fg+:#e0def4,hl+:#ea9a97
     --color=border:#44415a,header:#3e8fb0,gutter:#232136
     --color=spinner:#f6c177,info:#9ccfd8
     --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*'  menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Aliases
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
alias bbic='brew update && brew bundle install --cleanup --file=~/Brewfile && brew upgrade'
alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lah'
alias vi='nvim'
alias c='clear'
alias kanata='~/bin/kanata/target/release/kanata'
k() {
  sudo ~/bin/kanata/target/release/kanata -c ~/.config/kanata/kanata.kbd
}
alias digital='/opt/homebrew/Caskroom/digital/0.31/Digital/Digital.sh'

hash -d sync=/Users/k44n/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/sync

# Shell integrations
eval "$(fzf --zsh)"
