-- -- Notion main configuration file
--

-- Use the "Windows" key as prefix to most other commands
META="Mod4+"
ALTMETA="Mod4+Shift+"

-- The default config files are in /etc/X11/notion but can be overridden by
-- files in ~/.notion/
dopath("cfg_bindings")
dopath("cfg_kludges")
dopath("cfg_layouts")
dopath("mod_query")
dopath("mod_menu")
dopath("mod_tiling")
dopath("mod_dock")
dopath("mod_notionflux")
dopath("mod_xrandr")
dopath("net_client_list")

defbindings("WScreen", {
    bdoc("Restart Notion.", "restart"),
    kpress(META.."F11", "notioncore.restart()"),

    bdoc("Open terminal.", "terminal"),
    kpress(META.."BackSpace", "notioncore.exec_on(_, XTERM or 'x-terminal-emulator')"),

    bdoc("Open gvim.", "gvim"),
    kpress(META.."V", "notioncore.exec_on(_, 'gvim')"),

    bdoc("Open web browser.", "www"),
    kpress(META.."W", "notioncore.exec_on(_, 'sensible-browser')"),
    bdoc("Open web browser private window."),
    kpress(META.."Shift+W", "notioncore.exec_on(_, 'sensible-browser --private-window')"),

    bdoc("Open python.", "python"),
    kpress(META.."P", "notioncore.exec_on(_, (XTERM or 'x-terminal-emulator') .. ' -e ipython3')"),

    bdoc("Take a screenshot.", "shot"),
    kpress("Print", "notioncore.exec_on(_, 'xfce4-screenshooter')"),

    bdoc("Lock the screen.", "lock"),
    kpress("Control+Escape", "notioncore.exec_on(_, 'xdg-screensaver lock')"),

    bdoc("Suspend the computer (to RAM).", "sleep"),
    kpress("Mod1+Escape", "notioncore.exec_on(_, 'systemctl suspend')"),
})

-- Additional kludges

-- Allow some Xfce4 panel popup windows (such as datetime, whisker menu) to
-- float.
defwinprop{
  class="Wrapper-2.0",
  float=true,
  userpos=true,
}

-- Other panel popup windows (like the clock's calendar).
defwinprop {
  class="Xfce4-panel",
  name="",
  float=true,
  userpos=true,
}

-- Allow Inkscape dialog windows to be moved outside the parent window's
-- region.
defwinprop{
  class="Inkscape",
  is_transient=true,
  float=true,
}

-- Allow some KDE windows to float. See
-- https://userbase.kde.org/Tutorials/Using_Other_Window_Managers_with_Plasma
defwinprop{
  class="Plasma",
  float=true,
}

defwinprop{
  class="plasmashell",
  float=true,
}

-- Zoom (video calls). Generates lots of popups.
defwinprop{
  class="zoom",
  float=true,
}
