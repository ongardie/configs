# Xfce desktop environment

Copy `.config/xfce4/terminal/terminalrc` for a color theme in `xfce4-terminal`.

To use [Notion](./.notion/README.md):

```sh
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -n -a -t string -s notion
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client4_Command -n -a -t string -s true
```

The commands are based on <https://wiki.xfce.org/howto/other_window_manager>.
The first replaces `xfwm4` with `notion` in the default session, and the second
replaces `xfdesktop` (displays wallpaper) with `true` (exits immediately).

## Panel

The workspace switcher panel plugin doesn't work with Notion. As a workaround,
you can use a "generic monitor" with `bin/get-workspace` at a half-second
interval to display the current workspace.

I set up the panel manually like this:
- Whisker Menu
- Places (BTW, I created this panel plugin a long time ago when I was learning
  C. Thank you to the maintainers who have supported it after me, and I'm sorry
  for the noob code!)
- Some launchers (terminal, browser, etc)
- Generic Monitor for `bin/get-workspace`
- Window Menu
- Status Tray Plugin
- PulseAudio Plugin
- Clock (I maintained the `xfce4-datetime` plugin for a while, but the clock
  seems to have a suitable little calendar now)
