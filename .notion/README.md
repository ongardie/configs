# Notion window manager configs

This directory contains configuration files for the
[Notion window manager](https://notionwm.net/). The Lua files should be copied
or symlinked into `~/.notion/`.

Many of the configuration files are based on those that ship with Notion, but
the keybindings have been heavily customized (mostly to resemble older versions
of Notion and other window managers I used long ago). Most of the context
menu configuration is unchanged from Notion and split into `*_menu.lua`
files.

Notion v4, on which these files are based, is licensed under the LGPLv2.1.

To get a graphical overview of the keybindings in your web browser, type
`META + /'.

## Larger font sizes

The `make_look.sh` script can be used to replace the font size in the default
theme file:

```sh
./make_look.sh 12 > ~/.notion/look.lua
```

Then you'll have to reload Notion (bound to `META + F11` in these configs).
