#!/bin/zsh
echo 'lion\nasdf\n\nfjgh'
exit 0

input=$1
head=${input:0:1}
tail=${input:1}

if [[ $head == "=" ]]; then
    echo $(echo "scale=4; $tail" | bc 2>/dev/null)
elif [[ $head == ":" ]]; then
    echo $(ls --color=never ~/scripts/choosable | tr [:space:] \n\n)
elif [[ $head == "/" ]]; then
    app_list=$(ls --color=never /Applications/ /Applications/Utilities/ /System/Applications/ /System/Applications/Utilities/ | grep '\.app$' | sed 's/\.app$//g' | sort -u | sed 's/^/\//g')
    echo $app_list
fi
