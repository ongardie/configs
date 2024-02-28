#!/bin/sh

# The 'free' command uses a lot of extra whitespace by default. This
# function reformats the output for narrower terminals.
#
# Note: One downside of using `column` is that it can't right-align the
# columns. Anyway, normal `free --human` also screws this up a little when
# the units aren't the same width.

if command -v column >/dev/null; then
    # If 'free' is already defined as an alias, I'm not aware of a portable way
    # to define a function named 'free'.
    free_fn() {
        if command -v column >/dev/null; then
            {
                printf '.'
                command free --human --wide "$@"
            } | column -t
        else
            command free --human "$@"
        fi
    }
    alias free=free_fn
fi
