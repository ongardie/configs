#!/bin/sh

set -eu
cd

export PATH="$HOME/bin:$PATH"

do_backup() {
    RESTIC_HOME_SNAPSHOT=restic \
        restic.sh backup \
        --exclude "$HOME/.cache/" \
        --exclude "$HOME/.debug/" \
        --exclude "$HOME/.local/share/containers/" \
        --exclude "$HOME/.local/share/lxc/" \
        --exclude "$HOME/.local/share/libvirt/images/" \
        --exclude "$HOME/.local/share/Trash/" \
        --exclude "$HOME/.var/app/*/cache/" \
        --exclude "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox/*/storage/default/" \
        --exclude '.org.chromium.Chromium.*' \
        --exclude '.yarn' \
        --exclude '*.pyc' \
        --exclude 'node_modules' \
        --exclude-caches \
        --exclude-if-present '.nobck' \
        --exclude-if-present 'pyvenv.cfg' \
        --one-file-system \
        --verbose \
        /etc \
        "$HOME" \
        "$@"
}

resticpath=$(command -v restic)
if [ $(( $(date +%s) - $(stat --format %Y "$resticpath") > 60 * 60 * 24 )) -eq 1 ]; then
    echo "Updating $resticpath"
    restic self-update
    touch "$resticpath"
fi

echo "Saving lists of installed Debian packages to $HOME/bck"
mkdir -p bck
dpkg -l > bck/packages.txt
apt-mark showmanual > bck/packages.manual.txt

if [ -e /.zfs ]; then
    echo 'Creating ZFS snapshot'
    sudo zfs destroy -r 'rpool@restic' || true
    if ! sudo zfs snapshot -r 'rpool@restic'; then
        echo "ZFS snapshot failed"
        notify-send 'restic backup: ZFS snapshot failed!' \
           --urgency critical \
           --icon network-error
        exit 10
    fi
    export RESTIC_ZFS_SNAPSHOT=restic

    # Note: This script intentionally leaves this snapshot around so that you
    # can do things like:
    # sudo zfs diff rpool$HOME@restic
fi

echo 'Scanning for changes (dry run)'
# shellcheck disable=SC2310
dryrun=$(do_backup "$@" --dry-run --json --verbose=0 --quiet || echo "{failed: $?}")
echo "$dryrun" | jq .
mib=$(echo "$dryrun" | jq '.data_added / 1024 / 1024 | round' || echo 'N/A')

# For large backups, get explicit approval from the user. For small backups,
# give the user an opportunity to cancel (defer) but otherwise proceed.
if [ "$mib" = 'N/A' ] || [ "$mib" -gt 300 ]; then
    while true; do
        # Time out after a while as a way to not block backups indefinitely or
        # get stuck on an old snapshot.
        #
        # When notify-send expires, the exit status is 0, so it's impossible to
        # distinguish between experation and a click dismissing the
        # notification. Wrap it in 'timeout' to get a different exit status.
        st=0
        out=$(timeout 300 notify-send "Start large Restic backup ($mib MiB)?" \
               --action ok=OK \
               --action review=Review \
               --action cancel=Cancel \
               --expire-time 300000 \
               --icon task-due-symbolic) || st=$?
        if [ $st -ne 0 ]; then
            if [ $st -eq 124 ]; then
                echo "Notification timed out"
            else
                echo "Notification failed (status $st)"
            fi
            exit 11
        fi
        case "$out" in
            ok)
                echo 'User approved backup via notification'
                break
                ;;
            review)
                echo 'User reviewing backup'
                do_backup "$@" --dry-run --verbose=2 | grep -v '^unchanged ' | gvim -f -R -
                echo 'User done reviewing backup'
                ;;
            cancel)
                echo 'User canceled backup via notification'
                exit 12
                ;;
            *)
                echo 'Notification inconclusive (user dismissed it?). Trying again'
                ;;
        esac
    done
else
    out=$(notify-send "Starting Restic backup ($mib MiB)" \
            --action cancel=Cancel \
            --expire-time 5000 \
            --icon document-save \
            --urgency low)
    if [ "$out" = cancel ]; then
        echo 'User canceled backup via notification'
        exit 12
    fi
    echo 'Notification not canceled - proceeding'
fi

echo 'Starting backup'
st=0
# shellcheck disable=SC2310
do_backup "$@" || st=$?
if [ $st -eq 0 ]; then
    echo 'Restic backup succeeded'
    notify-send 'Restic backup succeeded' \
        --urgency low \
        --icon emblem-default \
        --expire-time 3000
else
    echo "Restic backup failed with status $st"
    notify-send 'Restic backup failed!' \
        --urgency critical \
        --icon network-error
fi
exit $st
