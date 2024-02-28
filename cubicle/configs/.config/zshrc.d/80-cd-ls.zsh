#!/bin/zsh

# Show truncated directory listing after cd
chpwd() {
    print -P "${PROMPT}%B%F{black}ls%f%b"
    count=0
    ls --color=always -C -w "$COLUMNS" | while read line; do
        echo "$line"
        if [ $count = $(( $LINES / 3 )) ]; then
            echo "...$(ls | wc -l) files total"
            break
        fi
        (( count = $count + 1 ))
    done
}
