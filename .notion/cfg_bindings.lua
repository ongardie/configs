--
-- Notion core configuration file
--

-- WScreen context bindings
--
-- The bindings in this context are available all the time.

defbindings("WScreen", {
    bdoc("Switch to object 0 (workspace, full screen client window) "..
         "within current screen.", "ws 0"),
    kpress(META.."1", "WScreen.switch_nth(_, 0)"),
    bdoc("Switch to object 1 (workspace, full screen client window) "..
         "within current screen.", "ws 1"),
    kpress(META.."2", "WScreen.switch_nth(_, 1)"),
    bdoc("Switch to object 2 (workspace, full screen client window) "..
         "within current screen.", "ws 2"),
    kpress(META.."3", "WScreen.switch_nth(_, 2)"),
    bdoc("Switch to object 3 (workspace, full screen client window) "..
         "within current screen.", "ws 3"),
    kpress(META.."4", "WScreen.switch_nth(_, 3)"),
    bdoc("Switch to object 4 (workspace, full screen client window) "..
         "within current screen.", "ws 4"),
    kpress(META.."5", "WScreen.switch_nth(_, 4)"),
    bdoc("Switch to object 5 (workspace, full screen client window) "..
         "within current screen.", "ws 5"),
    kpress(META.."6", "WScreen.switch_nth(_, 5)"),
    bdoc("Switch to object 6 (workspace, full screen client window) "..
         "within current screen.", "ws 6"),
    kpress(META.."7", "WScreen.switch_nth(_, 6)"),
    bdoc("Switch to object 7 (workspace, full screen client window) "..
         "within current screen.", "ws 7"),
    kpress(META.."8", "WScreen.switch_nth(_, 7)"),
    bdoc("Switch to object 8 (workspace, full screen client window) "..
         "within current screen.", "ws 8"),
    kpress(META.."9", "WScreen.switch_nth(_, 8)"),
    bdoc("Switch to object 9 (workspace, full screen client window) "..
         "within current screen.", "ws 9"),
    kpress(META.."0", "WScreen.switch_nth(_, 9)"),

    bdoc("Switch to previous object (workspace, full screen client window) "..
         "within current screen.", "<-ws"),
    kpress(META.."comma", "WScreen.switch_prev(_)"),
    bdoc("Switch to next object (workspace, full screen client window) "..
         "within current screen.", "->ws"),
    kpress(META.."period", "WScreen.switch_next(_)"),

    bdoc("Go to next screen on multihead setup.", "->scr"),
    kpress(META.."E", "ioncore.goto_next_screen()"),

    bdoc("Create a new workspace of chosen default type.", "+ws"),
    kpress(META.."F9", "ioncore.create_ws(_)"),

    bdoc("Backward-circulate focus.", "<-frame"),
    kpress(META.."H", "ioncore.goto_next(_chld, 'left')",
           "_chld:non-nil"),
    bdoc("Forward-circulate focus.", "->frame"),
    kpress(META.."L", "ioncore.goto_next(_chld, 'right')",
           "_chld:non-nil"),
})

-- Client window bindings
--
-- These bindings affect client windows directly.

defbindings("WClientWin", {
})

-- Client window group bindings

defbindings("WGroupCW", {
})


-- WMPlex context bindings
--
-- These bindings work in frames and on screens. The innermost of such
-- contexts/objects always gets to handle the key press.

defbindings("WMPlex", {
    bdoc("Close current object."),
    kpress_wait(META.."Q", "WRegion.rqclose_propagate(_, _sub)"),
})

-- Frames for transient windows ignore this bindmap

defbindings("WMPlex.toplevel", {
    bdoc("Toggle tag of current object.", "tag"),
    kpress(META.."T", "WRegion.set_tagged(_sub, 'toggle')", "_sub:non-nil"),

    bdoc("Query for command line to execute.", "run"),
    kpress(META.."R", "mod_query.query_exec(_)"),

    bdoc("Query for Lua code to execute.", "lua"),
    kpress(META.."F3", "mod_query.query_lua(_)"),

    bdoc("Show Notion 'live docs'.", "help"),
    kpress(META.."slash", "notioncore.show_live_docs(_)"),
})

-- WFrame context bindings
--
-- These bindings are common to all types of frames. Some additional
-- frame bindings are found in some modules' configuration files.

defbindings("WFrame", {
    bdoc("Maximize the frame horizontally/vertically.", "max"),
    kpress(META.."D", "WFrame.maximize_horiz(_); WFrame.maximize_vert(_)"),

    bdoc("Display context menu."),
    mpress("Button3", "mod_menu.pmenu(_, _sub, 'ctxmenu')"),

    bdoc("Switch the frame to display the object indicated by the tab."),
    mclick("Button1@tab", "WFrame.p_switch_tab(_)"),
    mclick("Button2@tab", "WFrame.p_switch_tab(_)"),

    bdoc("Resize the frame."),
    mdrag("Button1@border", "WFrame.p_resize(_)"),
    mdrag(META.."Button3", "WFrame.p_resize(_)"),

    bdoc("Move the frame."),
    mdrag(META.."Button1", "WFrame.p_move(_)"),

    bdoc("Move objects between frames by dragging and dropping the tab."),
    mdrag("Button1@tab", "WFrame.p_tabdrag(_)"),
    mdrag("Button2@tab", "WFrame.p_tabdrag(_)"),
})

-- Frames for transient windows ignore this bindmap

defbindings("WFrame.toplevel", {
    bdoc("Attach tagged objects to this frame.", "nick"),
    kpress(META.."A", "ioncore.tagged_attach(_)"),

    bdoc("Manipulate frame"),
    -- Display tab numbers when modifiers are released
    kpress(META.."F", "WFrame.set_numbers(_, 'during_grab')"),
    submap(META.."F", {
        bdoc("Switch to tab N in this frame.", "tab N"),
        kpress("1", "WFrame.switch_nth(_, 0)"),
        kpress("2", "WFrame.switch_nth(_, 1)"),
        kpress("3", "WFrame.switch_nth(_, 2)"),
        kpress("4", "WFrame.switch_nth(_, 3)"),
        kpress("5", "WFrame.switch_nth(_, 4)"),
        kpress("6", "WFrame.switch_nth(_, 5)"),
        kpress("7", "WFrame.switch_nth(_, 6)"),
        kpress("8", "WFrame.switch_nth(_, 7)"),
        kpress("9", "WFrame.switch_nth(_, 8)"),
        kpress("0", "WFrame.switch_nth(_, 9)"),

        bdoc("Switch to next/previous object within the frame."),
        kpress("L", "WFrame.switch_next(_)"),
        kpress("H", "WFrame.switch_prev(_)"),
        kpress("J", "WFrame.switch_next(_)"),
        kpress("K", "WFrame.switch_prev(_)"),
    }),
})

-- Bindings for floating frames

defbindings("WFrame.floating", {
    bdoc("Toggle shade mode"),
    mdblclick("Button1@tab", "WFrame.set_shaded(_, 'toggle')"),

    bdoc("Raise the frame."),
    mpress("Button1@tab", "WRegion.rqorder(_, 'front')"),
    mpress("Button1@border", "WRegion.rqorder(_, 'front')"),
    mclick(META.."Button1", "WRegion.rqorder(_, 'front')"),

    bdoc("Lower the frame."),
    mclick(META.."Button3", "WRegion.rqorder(_, 'back')"),

    bdoc("Move the frame."),
    mdrag("Button1@tab", "WFrame.p_move(_)"),
})

-- WMoveresMode context bindings
--
-- These bindings are available keyboard move/resize mode.

defbindings("WMoveresMode", {
})

dopath('cfg_bindings_menu')
