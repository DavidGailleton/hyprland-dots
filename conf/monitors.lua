-- Monitors — `hyprctl monitors` lists names/modes.

-- Laptop panel (1920x1080, 1.5 scale for a 14"-ish screen)
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = 1.5,
})

-- Anything plugged in: best mode, placed to the right, auto scale
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
