#!/usr/bin/env nu

def --wrapped bat [...rest] {
    if (which ^bat | is-not-empty) {
        ^bat ...$rest
    } else {
        # batcat is how it's packaged by Debian, so default to this for package
        # suggestions.
        ^batcat ...$rest
    }
}

def --wrapped dash [...rest] {
    if (which ^rlwrap | is-not-empty) {
        ^rlwrap dash ...$rest
    } else {
        ^dash ...$rest
    }
}

alias diff = diff --new-file --recursive --unified

def --wrapped fd [...rest] {
    if (which ^fd | is-not-empty) {
        ^fd ...$rest
    } else {
        # fdfind is how it's packaged by Debian, so default to this for package
        # suggestions.
        ^fdfind ...$rest
    }
}

alias feh = feh --scale-down
alias gitk = gitk --all
alias gpg = gpg --no-symkey-cache
alias gvim = gvim -p
alias py = ipython3

def timestamp [] {
    date now | format date '%Y-%m-%dT%H:%M:%SZ'
}

alias vim = vim -p
