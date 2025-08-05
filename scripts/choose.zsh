#!/bin/zsh

# --- Configuration ---
# Directory for custom user scripts
CHOOSABLE_SCRIPTS_DIR="$HOME/scripts/choosable"

app_list=$(ls --color=never /Applications/ /Applications/Utilities/ /System/Applications/ /System/Applications/Utilities/ | grep '\.app$' | sed 's/\.app$//g' | sort -u)

if [ -d "$CHOOSABLE_SCRIPTS_DIR" ]; then
    script_list=$(ls "$CHOOSABLE_SCRIPTS_DIR" | while read -r script; do
            if [ -x "$CHOOSABLE_SCRIPTS_DIR/$script" ]; then
                echo "$script"
            fi
        done)
else
    script_list=""
fi

full_list=$(echo -e "$app_list\n$script_list")

# The '-m' flag allows 'choose' to return the query even if it doesn't match any item.
selection=$(echo -e "$full_list" | choose -p "Search" -m)

# Check if the selection is a mathematical expression.
# It uses a regex to check for numbers and common math operators.
if [[ "$selection" =~ ^[0-9\+\-\*\/\(\)\. ]+$ && $(echo "$selection" | bc 2>/dev/null) ]]; then
    result=$(echo "scale=4; $selection" | bc)
    echo "$result" | choose -p "Result"
#    elif grep -q "^${selection}$" <<< "$app_list"; then
#        # If the selection is an application, launch it.
#        # 'open' is used to start GUI applications on macOS.
#        open -a "$selection"
#    elif [ -n "$script_list" ] && grep -q "^${selection}$" <<< "$script_list"; then
#        # If the selection is a script from the choosable directory, execute it.
#        "$CHOOSABLE_SCRIPTS_DIR/$selection"
# Use grep with -F (fixed strings) and -x (whole line match) for robustness.
# printf is used to safely pass the list to grep's stdin.
elif printf '%s\n' "$app_list" | grep -qFx -- "$selection"; then
    # If the selection is an application, launch it.
    # 'open' is used to start GUI applications on macOS.
    open -a "$selection"
# Similar robust grep usage for script list.
elif [ -n "$script_list" ] && printf '%s\n' "$script_list" | grep -qFx -- "$selection"; then
    # If the selection is a script from the choosable directory, execute it.
    "$CHOOSABLE_SCRIPTS_DIR/$selection"
else
    # If the input doesn't match any known item, you could add a fallback action here.
    # For example, performing a web search.
    echo "No action found for: $selection" | choose -p "Error"
fi
