[Flatpak](https://www.flatpak.org/) is a cross-distro way to package
applications as containers for Linux. It runs the applications in a sandbox
with possibly limited permissions.

## Install/configure Flatpak itself

```sh
sudo apt install flatpak
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

You may need to log out and back in or reboot.

### Flatpak updates

> Warning: It is generally not a good idea to run unattended updates via
> systemd, as the applications can get new permissions without the user aware
> of the changes.
>  -- <https://wiki.archlinux.org/title/Flatpak#Automatic_updates_via_systemd>

Still, this is probably better than no updates.

```sh
mkdir -p ~/.config/systemd/user/
cp -ai .config/systemd/user/flatpak-update.{service,timer} ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now flatpak-update.timer
```

## Installing software with Flatpak

You can search for software on [Flathub](https://flathub.org/).

### 1Password (official)

From <https://support.1password.com/install-linux/#flatpak>:

```sh
flatpak install --user https://downloads.1password.com/linux/flatpak/1Password.flatpakref
```

### Chrome (unofficial)

```sh
flatpak install --user flathub com.google.Chrome
```

### D-Spy

[D-Spy](https://gitlab.gnome.org/GNOME/d-spy) is a D-Bus browser/GUI.

```sh
flatpak install --user org.gnome.dspy
```

### Firefox

```sh
flatpak install --user flathub org.mozilla.firefox
```

To work around an [issue](https://bugzilla.mozilla.org/show_bug.cgi?id=1621915)
with Firefox preferring bitmap fonts:

```sh
mkdir -p ~/.var/app/org.mozilla.firefox/config/fontconfig/
cp -i fonts.conf ~/.var/app/org.mozilla.firefox/config/fontconfig/fonts.conf
```

You'll need to restart Firefox for it to pick this up.

Set Firefox as the default web browser:

```sh
xdg-mime default org.mozilla.firefox.desktop text/html
xdg-mime default org.mozilla.firefox.desktop x-scheme-handler/http
xdg-mime default org.mozilla.firefox.desktop x-scheme-handler/https
```

(You can check these with `xdg-mime query text/html`, etc.)

See [../firefox.md](../firefox.md) for configuring Firefox.

### Flatseal

Useful for reviewing and editing flatpak overrides.

```sh
flatpak install --user flathub com.github.tchx84.Flatseal
```

You can usually also do this to try things out from the perspective of the
application:

```sh
flatpak ps
flatpak enter INSTANCE /bin/bash
```

### Signal (unofficial)

```sh
flatpak install --user flathub org.signal.Signal
```

### Spotify (unofficial)

```sh
flatpak install --user flathub com.spotify.Client
```

### Zoom (unofficial)

```sh
flatpak install --user flathub us.zoom.Zoom
```

## Set up convenient executables

```sh
./flatpak-wrappers.sh
```
