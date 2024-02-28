#!/bin/sh

if command -v batcat >/dev/null && ! command -v bat >/dev/null; then
    alias bat='batcat'
fi
if command -v rlwrap >/dev/null; then
    alias dash='rlwrap dash'
fi
alias diff='diff --new-file --recursive --unified'
if command -v fdfind >/dev/null && ! command -v fd >/dev/null; then
    alias fd='fdfind'
fi
alias feh='feh --scale-down'
alias gitk='gitk --all'
alias gpg='gpg --no-symkey-cache'
alias gvim='gvim -p'
if [ -n "${ZSH_VERSION:-}" ]; then
    alias help='run-help'
elif [ -n "${BASH_VERSION:-}" ]; then
    alias run-help='help'
fi
case "${PAGER:-}" in
    less*)
        # shellcheck disable=SC2139
        alias less="$PAGER"
        ;;
esac
alias py='ipython3'
alias timestamp='date --utc "+%Y-%m-%dT%H:%M:%SZ"'
alias vim='vim -p'
