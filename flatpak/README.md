[Flatpak](https://www.flatpak.org/) is a cross-distro way to package
applications as containers for Linux. It runs the applications in a sandbox
with possibly limited permissions.

## Install/Configure Flatpak Itself

```sh
sudo apt install flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

You may need to log out and back in or reboot.

### Flatpak Updates

> Warning: It is generally not a good idea to run unattended updates via
> systemd, as the applications can get new permissions without the user aware
> of the changes.
>  -- <https://wiki.archlinux.org/title/Flatpak#Automatic_updates_via_systemd>

Still, this is probably better than no updates.

```sh
sudo cp etc/systemd/user/* /etc/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now flatpak-update.timer
```

## Installing Software with Flatpak

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

### Zoom

```sh
flatpak install flathub us.zoom.Zoom
```
