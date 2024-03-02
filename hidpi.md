# HiDPI

For high-resolution displays, there are quite a few things to adjust.

See also <https://wiki.archlinux.org/title/HiDPI>.

## GRUB

You can find supported resolutions with:

```sh
sudo hwinfo --framebuffer
```

To lower the resolution in Grub, modify `/etc/default/grub`:

```diff
-#GRUB_GFXMODE=640x480
+GRUB_GFXMODE=1024x768,auto
```

You can list additional resolutions separated by commas.

Then run:

```sh
sudo update-grub
```

## Linux console

To increase the font size in the Linux console:

```sh
sudo dpkg-reconfigure console-setup
```

Select the "Terminus" font and then the "16x32 (framebuffer only)" size.

## Xorg

Create `/etc/X11/xorg.conf.d/90-monitor.conf`:

```
Section "Monitor"
    Identifier "<default monitor>"
    DisplaySize 294 165 # millimeters
EndSection
```

Once you restart X, you can verify this with:

```sh
xdpyinfo | grep -B2 resolution
```

```sh
sudo update-alternatives --set x-cursor-theme /usr/share/icons/Adwaita/cursor.theme
```

## Lightdm

```sh
sudo tee /usr/local/bin/gdk-hidpi-wrapper.sh << 'END'
#!/bin/sh
GDK_SCALE=2 exec "$@"
END
sudo chmod +x /usr/local/bin/gdk-hidpi-wrapper.sh
sudo sed -Ei 's/#(greeter-wrapper)=$/\1=gdk-hidpi-wrapper.sh/' /etc/lightdm/lightdm.conf
sudo tee --append /etc/lightdm/lightdm-gtk-greeter.conf << 'END'
cursor-theme-name=Adwaita
cursor-theme-size=64
END
sudo systemctl restart lightdm
```

## GTK/Xfce

```sh
xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s 2
xfconf-query -c xfwm4 -p /general/theme -s Default-xhdpi
xfconf-query --channel xsettings --property /Gtk/CursorThemeName --set Adwaita
xfconf-query --channel xsettings --property /Gtk/CursorThemeSize --set 64
gsettings set org.gnome.desktop.interface cursor-theme Adwaita
gsettings set org.gnome.desktop.interface cursor-size 64
```

Note: The `/Gtk/CursorThemeName` seems to affect Firefox in Flatpak.

## Notion

Bring the title bars back down to a reasonable size:

```sh
~/.notion/make_look.sh 8 > ~/.notion/look.lua
```
