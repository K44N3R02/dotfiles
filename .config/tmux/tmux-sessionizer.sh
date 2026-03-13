#!/bin/bash

PATH="/opt/homebrew/bin:$PATH"

# fzf rosepine theme
export FZF_DEFAULT_OPTS="
     --color=fg:#908caa,hl:#ea9a97
     --color=fg+:#e0def4,hl+:#ea9a97
     --color=border:#44415a,header:#3e8fb0,gutter:#232136
     --color=spinner:#f6c177,info:#9ccfd8
     --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

switch_to() {
    if [[ -z $TMUX ]]; then
        tmux attach-session -t $1
    else
        tmux switch-client -t $1
    fi
}

has_session() {
    tmux list-sessions | grep -q "^$1:"
}

hydrate() {
    if [ -f $2/.tmux-sessionizer ]; then
        tmux send-keys -t $1 "source $2/.tmux-sessionizer" c-M
    elif [ -f $HOME/.tmux-sessionizer ]; then
        tmux send-keys -t $1 "source $HOME/.tmux-sessionizer" c-M
    fi
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    # If someone wants to make this extensible, i'll accept
    # PR
    selected=$((echo "/Users/k44n"; find ~/learn/** ~/projects/** ~/.config ~/odtu/** -mindepth 1 -maxdepth 1 -type d) | fzf --margin 10%)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    hydrate $selected_name $selected
    exit 0
fi

if ! has_session $selected_name; then
    tmux new-session -ds $selected_name -c $selected
    hydrate $selected_name $selected
fi

switch_to $selected_name
