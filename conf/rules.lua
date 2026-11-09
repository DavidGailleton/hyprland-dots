-- Window & layer rules. Find classes with `hyprctl clients`, layers with `hyprctl layers`.

-- ── Glass: translucency only where text stays readable ─────────────────────
-- (browsers, video, Obsidian stay opaque on purpose)
hl.window_rule({
    name    = "glass-terminal",
    match   = { class = "^(kitty)$" },
    opacity = "0.88 override 0.80 override 1.0 override",
})
hl.window_rule({
    name    = "glass-files",
    match   = { class = "^([Tt]hunar|org.pulseaudio.pavucontrol|blueman-manager|nm-connection-editor)$" },
    opacity = "0.92 override 0.85 override",
})

-- ── Floating utilities ─────────────────────────────────────────────────────
hl.window_rule({
    name   = "float-utilities",
    match  = { class = "^(org.pulseaudio.pavucontrol|blueman-manager|nm-connection-editor|com.gabm.satty|hyprland-run|qt6ct|qt5ct)$" },
    float  = true,
    center = true,
    size   = { "monitor_w * 0.5", "monitor_h * 0.6" },
})
hl.window_rule({
    name   = "float-dialogs",
    match  = { title = "^(Open File|Open Folder|Save As|Save File|File Upload|Select a File|Choose Files|Confirm to replace files|File Operation Progress)(.*)$" },
    float  = true,
    center = true,
})
hl.window_rule({
    name  = "float-pip",
    match = { title = "^(Picture-in-Picture|Picture in picture)$" },
    float = true,
    pin   = true,
    size  = { "monitor_w * 0.28", "monitor_h * 0.28" },
    move  = { "monitor_w * 0.71", "monitor_h * 0.68" },
})

-- polkit agent: centered, dim the rest
hl.window_rule({
    name       = "polkit",
    match      = { class = "^(hyprpolkitagent)$" },
    float      = true,
    center     = true,
    dim_around = true,
})

-- ── Sane defaults (from the stock config) ──────────────────────────────────
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- ── Layers: blur behind Quickshell panels and rofi ─────────────────────────
-- Quickshell windows set namespaces "qs-bar", "qs-notifications", "qs-osd", …
hl.layer_rule({ name = "qs-glass",   match = { namespace = "^qs-.*" }, blur = true, ignore_alpha = 0.3 })
hl.layer_rule({ name = "rofi-glass", match = { namespace = "^rofi$" }, blur = true, ignore_alpha = 0.3, dim_around = true })
-- screenshot selection: no fade, no blur
hl.layer_rule({ name = "selection",  match = { namespace = "^(selection|hyprpicker)$" }, no_anim = true })
