--
-- Menu definitions (copied from Notion's cfg_bindings.lua)
--

-- Context menu (frame actions etc.)
defctxmenu("WFrame", "Frame", {
    -- Note: this propagates the close to any subwindows; it does not
    -- destroy the frame itself, unless empty. An entry to destroy tiled
    -- frames is configured in cfg_tiling.lua.
    menuentry("Close",          "WRegion.rqclose_propagate(_, _sub)"),
    -- Low-priority entries
    menuentry("Attach tagged", "ioncore.tagged_attach(_)", { priority = 0 }),
    menuentry("Clear tags",    "ioncore.clear_tags()", { priority = 0 }),
    menuentry("Window info",   "mod_query.show_tree(_, _sub)", { priority = 0 }),
})


-- Context menu for groups (workspaces, client windows)
defctxmenu("WGroup", "Group", {
    menuentry("Toggle tag",     "WRegion.set_tagged(_, 'toggle')"),
    menuentry("De/reattach",    "ioncore.detach(_, 'toggle')"),
})


-- Context menu for workspaces
defctxmenu("WGroupWS", "Workspace", {
    menuentry("Close",          "WRegion.rqclose(_)"),
    menuentry("Rename",         "mod_query.query_renameworkspace(nil, _)"),
    menuentry("Attach tagged",  "ioncore.tagged_attach(_)"),
})


-- Context menu for client windows
defctxmenu("WClientWin", "Client window", {
    menuentry("Kill",           "WClientWin.kill(_)"),
})
