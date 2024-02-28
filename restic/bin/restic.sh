#!/bin/bash
#
# Note: This script uses an array, so don't run it with dash.

set -eu

if [ -f ~/.config/restic.env ]; then
    # shellcheck source=/dev/null
    . ~/.config/restic.env
else
    mkdir -p ~/.config
    cat > ~/.config/restic.env <<'END'
#!/bin/sh

export RESTIC_PASSWORD='TODO'
export RESTIC_REPOSITORY='TODO'
export B2_ACCOUNT_ID='TODO'
export B2_ACCOUNT_KEY='TODO'

# Optionally, you can override the hostname. For example, you can append a
# version number to the hostname after reinstalling a machine.
restic_hostname="$(hostname --short)"
export restic_hostname
END
fi

if [ "${RESTIC_REPOSITORY:-TODO}" = TODO ] ; then
    echo 'ERROR: You must configure ~/.config/restic.env before running backups'
    exit 1
fi


args=()


# I've found it helpful to use a "versioned" hostname with restic after
# reinstalling a machine (just appending 2 to the hostname). There's no
# environment variable for this; see
# <https://github.com/restic/restic/issues/1984>. `restic backup` accepts a
# `--host` argument, but other restic subcommands (`ls`, `stats`) take `--host`
# to mean something different. Fortunately, Bubblewrap can fake the hostname
# with `--hostname` and `-unshare-uts`.
if [ -n "${restic_hostname}" ]; then
    args=("${args[@]}" --hostname "$restic_hostname" --unshare-uts)
fi

# Use the ZFS snapshots named `$RESTIC_ZFS_SNAPSHOT`, if set, instead of normal
# file accesses. A wishlist issue for adding this feature to Restic is
# <https://github.com/restic/restic/issues/3557>.
for mountpoint in $(findmnt --types zfs --output target --list --noheadings); do
    # Skip any hidden .zfs mounts. Also skip /var/lib/docker/zfs, since it's
    # got a lot of bind mounts and isn't backed up.
    case "$mountpoint" in
        */.zfs/*|/var/lib/docker/zfs/*)
            continue
            ;;
    esac

    if [ -n "${RESTIC_ZFS_SNAPSHOT:-}" ]; then
        args=("${args[@]}" --ro-bind "$mountpoint/.zfs/snapshot/$RESTIC_ZFS_SNAPSHOT" "$mountpoint")
    else
        # This should do roughly nothing, but it keeps restic's environment
        # more similar to when snapshots are used.
        args=("${args[@]}" --ro-bind "$mountpoint" "$mountpoint")
    fi
done

# Give restic read-write access to its cache dir.
args=("${args[@]}" --bind "$HOME/.cache/restic" "$HOME/.cache/restic")

# Give restic read-write access to a subdir within $TMPDIR.
restic_tmpdir="${TMPDIR:-/tmp}/restic"
mkdir -p "$restic_tmpdir"
args=(
    "${args[@]}"
    --bind "$restic_tmpdir" "$restic_tmpdir"
    --setenv TMPDIR "$restic_tmpdir"
)

resticpath=$(command -v restic)

# TODO: It should be possible to use `CAP_DAC_READ_SEARCH` to drop some
# privileges so that restic can access all files but still run as `$USER`. See
# <https://restic.readthedocs.io/en/stable/080_examples.html#full-backup-without-root>.
exec sudo --preserve-env -- \
    bwrap \
    "${args[@]}" \
    -- \
    "$resticpath" "$@"
