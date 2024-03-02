# ongardie's config files

This repo contains instructions and configuration files for setting up Linux
systems. These reflect my own preferences, but you might find useful snippets
in here, too.

Some of the files in this repo begin with a dot, so use `ls -a` to see them.

## System configuration

- [`debian-on-zfs.md`](./debian-on-zfs.md) has instructions for installing
  Debian with ZFS.
- [`hardware`](./hardware/) contains some reference and quirks about specific
  hardware I use.
- [`apt`](./apt/README.md) has instructions for setting up APT for Debian
  Bookworm.
- [`ufw.md`](./ufw.md) has instructions for setting up a firewall.
- [`ssh.md`](./ssh.md) has instructions for setting up an SSH server.
- [`wireguard.md`](./wireguard.md) has instructions for setting up a VPN.
- [`user-account.md`](./user-account.md) has instructions for adding system
  users.

## Debian packages

[`debian-base`](./debian-base) contains useful Debian Bookworm packages for
both servers and workstations. You can install these packages with:

```sh
sudo apt install $(sed 's/#.*//' debian-base)
```

[`debian-desktop`](./debian-desktop) contains useful packages for graphical
desktops/laptops. You can install these packages with:

```sh
sudo apt install $(sed 's/#.*//' debian-desktop)
```

## CLI configuration

The shell and UNIX-y configurations are mostly shared with
[Cubicle](https://github.com/ongardie/cubicle/) configs, with quite a bit of
layering. This includes:
- Bash,
- Zsh,
- vim,
- git,
- and some miscellany.

Use `install.py` to easily flatten the layers and install these configs on the
host:

```sh
mkdir -p ~/opt
git clone https://github.com/ongardie/cubicle/ ~/opt/cubicle
./install.py --cubicle ~/opt/cubicle --dry-run
```

Review what this would do, then drop the `--dry-run`.


## Desktop

I usually use lightdm with Xfce (see [`xfce.md`](./xfce.md)) and the Notion
window manager (see [`.notion`](./.notion/README.md)). An older
[`.xsession`](./.xsession) script is an alternative to avoid some or all of
Xfce (for more minimal setups or very resource-constrained machines).

See [`hidpi.md`](./hidpi.md) for high-resolution displays.

See [`flatpak`](./flatpak/README.md) for sandboxed Desktop applications.

See [`firefox.md`](./firefox.md) for configuring Firefox, which I usually
install via Flatpak.

To enable audio for your user account:

```sh
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

## Backups

See [`restic`](./restic/README.md) for setting up backups.
