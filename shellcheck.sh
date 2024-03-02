#!/bin/sh

set -eu

OPTS='avoid-nullary-conditions,check-set-e-suppressed'

shellcheck \
    --enable "$OPTS" \
    "$@" \
    .xsession \
    .xsessionrc \
    bin/backlight \
    bin/get-workspace \
    bin/update-completions

find . -type f \( -name '*.sh' -or -name '*.bash' \) -exec shellcheck --enable "$OPTS" "$@" {} \+
