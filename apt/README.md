The files in this directory are meant to be installed in `/etc/apt/` on a
Debian 10 (Buster) system.

## Sources

The file `sources.list` and the directory `sources.list.d` contain lists of
package repositories.

## Preferences

The directory `preferences.d` describes which packages `apt` should install
from which repositories. See `man apt_preferences` for reference, especially
the "How APT Interprets Priorities" section. Note that order sometimes matters.
Debug this with `apt policy` and `apt policy <package>`.

Create a file like `10local` for computer-specific changes.

## Keys

If you're using these external repositories, you'll also need to accept their
signing keys.

[Signal](https://signal.org/download/):

```sh
curl -sS https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
```

[Spotify](https://www.spotify.com/us/download/linux/):

```sh
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
```

[VSCodium](https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo):

```sh
curl -sS https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
``
