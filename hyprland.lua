-- ╭──────────────────────────────────────────────────────────╮
-- │  Hyprland — entry point                                  │
-- │  Each module is its own require() scope: an error in one │
-- │  file does not stop the others from loading.             │
-- ╰──────────────────────────────────────────────────────────╯
-- Docs: https://wiki.hypr.land/  ·  check errors: hyprctl configerrors

require("conf.monitors")
require("conf.env")
require("conf.look")        -- colors (matugen), gaps, blur, shadows
require("conf.animations")
require("conf.input")
require("conf.rules")
require("conf.binds")
require("conf.autostart")
