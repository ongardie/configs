#!/bin/zsh

set -o vi
# Re-enable Ctrl-R searching through history
bindkey '^R' history-incremental-search-backward
# For multi-line pasted input, allow backspace to delete line break.
bindkey -M viins '^?' backward-delete-char
