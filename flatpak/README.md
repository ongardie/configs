[Flatpak](https://www.flatpak.org/) is a cross-distro way to package
applications as containers for Linux. It runs the applications in a sandbox
with possibly limited permissions.

## Install/configure Flatpak itself

```sh
sudo apt install flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

You may need to log out and back in or reboot.

### Flatpak updates

> Warning: It is generally not a good idea to run unattended updates via
> systemd, as the applications can get new permissions without the user aware
> of the changes.
>  -- <https://wiki.archlinux.org/title/Flatpak#Automatic_updates_via_systemd>

Still, this is probably better than no updates.

```sh
sudo cp -ai etc/systemd/user/flatpak-update.{service,timer} /etc/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now flatpak-update.timer
```

## Installing software with Flatpak

You can search for software on [Flathub](https://flathub.org/).

### Chrome (unofficial)

```sh
flatpak install flathub com.google.Chrome
```

### Firefox

```sh
flatpak install flathub org.mozilla.firefox
```

To work around an [issue](https://bugzilla.mozilla.org/show_bug.cgi?id=1621915)
with Firefox preferring bitmap fonts:

```sh
mkdir -p .var/app/org.mozilla.firefox/config/fontconfig/
cp -i fonts.conf .var/app/org.mozilla.firefox/config/fontconfig/fonts.conf
```

You'll need to restart Firefox for it to pick this up.

See [../firefox.md](../firefox.md) for configuring Firefox.

### Flatseal

Useful for reviewing and editing flatpak overrides.

```sh
flatpak install flathub com.github.tchx84.Flatseal
```

You can usually also do this to try things out from the perspective of the
application:

```sh
flatpak ps
flatpak enter INSTANCE /bin/bash
```

### Signal (unofficial)

```sh
flatpak install flathub org.signal.Signal
```

### Spotify (unofficial)

```sh
flatpak install flathub com.spotify.Client
```

### Zoom (unofficial)

```sh
flatpak install flathub us.zoom.Zoom
```

## Set up convenient executables

Run `./flatpak-wrappers.sh`.
