--
-- Notion tiling module configuration file
--

-- Bindings for the tilings.
defbindings("WTiling", {
    bdoc("Split current into columns.", "hsplit"),
    kpress(META.."S", "WTiling.split_at(_, _sub, 'right', true)"),

    bdoc("Go to frame below current frame.", "vframe"),
    kpress(META.."J", "ioncore.goto_next(_sub, 'down', {no_ascend=_})"),
    bdoc("Go to frame above current frame.", "^frame"),
    kpress(META.."K", "ioncore.goto_next(_sub, 'up', {no_ascend=_})"),

    bdoc("Manipulate tiling."),
    submap(META.."F", {
        bdoc("Split current into rows.", "vsplit"),
        kpress("S", "WTiling.split_at(_, _sub, 'bottom', true)"),

        bdoc("Destroy current frame.", "unsplit"),
        kpress("X", "WTiling.unsplit_at(_, _sub)"),
    }),
})

-- Frame bindings.
defbindings("WFrame.floating", {
})

dopath('cfg_tiling_menu')
