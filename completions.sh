#!/bin/sh

# This script installs tab completion scripts for Bash and Zsh shells. You
# should re-run it occasionally. It's probably OK if some of this fails.

BASH_COMP=~/.local/share/bash-completion/completions
ZSH_COMP=~/.zfunc

mkdir -p $BASH_COMP $ZSH_COMP

rustup completions bash > $BASH_COMP/rustup
rustup completions zsh > $ZSH_COMP/_rustup

rustup completions bash cargo > $BASH_COMP/cargo
rustup completions zsh cargo > $ZSH_COMP/_cargo
