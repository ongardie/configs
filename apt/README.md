The files in this directory are meant to be installed in `/etc/apt/` on a
Debian 12 (Bookworm) system. See also the `debian-base` and `debian-desktop`
package lists in the root of this repository, which contain lists of useful
packages.

## Sources

The directory `sources.list.d` contains lists of package repositories.

## Preferences

The directory `preferences.d` describes which packages `apt` should install
from which repositories. See `man apt_preferences` for reference, especially
the "How APT Interprets Priorities" section. Note that order sometimes matters.
Debug this with `apt policy` and `apt policy <package>`.

Create a file like `10local` for computer-specific changes.

## Keys

If you're using these external repositories, you'll also need to set up their
signing keys.

[1Password](https://support.1password.com/install-linux/):

```sh
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
```

[Signal](https://signal.org/download/):

```sh
curl -sS https://updates.signal.org/desktop/apt/keys.asc | sudo gpg --dearmor --output /usr/share/keyrings/signal.gpg
```

## Disable `recommends`

Debian packages can recommended others, and these get installed by default.
Some of these are useful, but sometimes they add quite a bit of bloat. You can
disable this if you're ok with occasional breakage; try to review what you're
missing as you install new packages.

```sh
echo 'Apt::Install-Recommends "0";' | sudo tee > /etc/apt/apt.conf.d/90recommends
```

## Set up automatic updates

```sh
sudo apt install unattended-upgrades
```
