#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Smart Delete Word
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Send alt+backspace when you hit ctrl+w if the app is not terminal

tell application "System Events"
    set frontApp to name of first process whose frontmost is true

    if frontApp is "Terminal" or frontApp is "ghostty" or frontApp is "Code" then
        keystroke "w" using control down
    else
        key code 51 using option down
    end if
end tell
