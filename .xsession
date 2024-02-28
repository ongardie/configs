#!/bin/sh

# This sets up a graphical desktop environment. It works with both startx and
# lightdm. Save it as `~/.xsession`.

set -e

if [ -f ~/.xsessionrc ]; then
  # shellcheck source=/dev/null
  . ~/.xsessionrc
elif [ -f ~/.profile ]; then
  # shellcheck source=/dev/null
  . ~/.profile
fi

if [ -f ~/.Xresources ]; then
  xrdb ~/.Xresources
fi

# Use light-locker when running under lightdm, but fall back to xscreensaver
# otherwise.
if [ -n "$XDG_SESSION_PATH" ] && command -V light-locker > /dev/null; then
  light-locker --lock-on-lid &
  xset s on
else
  xscreensaver -nosplash &
  xss-lock -- xscreensaver-command --lock &
fi

if command -V xfce4-panel > /dev/null; then
  xfce4-panel --sm-client-disable --disable-wm-check &
  xfsettingsd --daemon --disable-wm-check
else
  trayer --widthtype request --transparent true --alpha 255 &
fi
nm-applet &
blueman-applet &

notion
