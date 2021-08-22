The files in this directory are meant to be installed in `/etc/apt/` on a
Debian 11 (Bullseye) system. See also the `debian-base` and `debian-desktop`
package lists in the root of this repository.

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

[Spotify](https://www.spotify.com/us/download/linux/):

```sh
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo gpg --dearmor --output /usr/share/keyrings/spotify.gpg
```

[VSCodium](https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo):

```sh
curl -sS https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo gpg --dearmor --output /usr/share/keyrings/vscodium.gpg
```
