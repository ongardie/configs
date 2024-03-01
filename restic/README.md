# restic backups

## Install `restic`

Download the latest release of `restic` from
<https://github.com/restic/restic/releases>.

Unpack the ...`linux_amd64.bz2` file, make it executable, and move it to
`~/bin/restic`.

## Set up restic wrapper and backup scripts

`restic` needs quite a few options to access a repository, so it's convenient
to set these up in a wrapper script. This script is also useful for making
restic work with ZFS snapshots and potentially lying about your hostname.

```sh
cp -aiv bin/restic.sh ~/bin/
restic.sh --help # generate the template
sensible-editor ~/.config/restic.env # fill out the template
restic.sh snapshots --compact --latest 3
```

## Set up the backup script

The backup script will call the wrapper to take new backups.

```sh
cp -aiv bin/restic-backup.sh ~/bin/
~/bin/restic-backup.sh
```

## Set up a systemd timer

```sh
mkdir -p ~/.config/systemd/user
cp -ai .config/systemd/user/restic.{service,timer} ~/.config/systemd/user
systemctl --user daemon-reload
systemctl --user enable --now restic.timer
systemctl --user enable --now restic.service
```

The timer will cause the backup script to update restic as new versions become
available.

## Trigger a backup

It's best to use systemd rather than running `restic-backup.sh` directly,
in case systemd decides to run a backup concurrently.

```sh
systemctl --user restart restic.service
```

Check the status:
```sh
systemctl --user status restic.timer restic.service
```

Check the logs:

```sh
journalctl --user -u restic.service
```
