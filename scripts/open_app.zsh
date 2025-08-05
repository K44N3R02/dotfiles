#!/bin/zsh

main() {
    case $(aerospace list-workspaces --focused) in
        1) open -a "Whatsapp.app"
            ;;
        2) open -a "Ghostty.app"
            ;;
        3) open -a "Zen.app"
            ;;
        4) open -a "Obsidian.app"
            ;;
    esac
}

main
