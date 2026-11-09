-- Keybinds. SUPER = main modifier.  List live binds: `hyprctl binds`.

local mod  = "SUPER"
local home = os.getenv("HOME")
local scripts = home .. "/.config/hypr/scripts/"

-- Launch apps through UWSM so they become proper systemd scopes.
local function app(cmd) return hl.dsp.exec_cmd("uwsm app -- " .. cmd) end
local function sh(cmd)  return hl.dsp.exec_cmd(cmd) end
local function qs(target, fn) return sh("qs ipc call " .. target .. " " .. fn) end

-- ── Apps ───────────────────────────────────────────────────────────────────
hl.bind(mod .. " + Return",        app("kitty"))
hl.bind(mod .. " + E",             app("thunar"))
hl.bind(mod .. " + B",             app("librewolf"))
hl.bind(mod .. " + Space",         sh("pkill -x rofi || uwsm app -- rofi -show drun"))
hl.bind(mod .. " + Tab",           sh("pkill -x rofi || rofi -show window"))
hl.bind(mod .. " + V",             sh(scripts .. "clipboard.sh"))
hl.bind(mod .. " + W",             sh(scripts .. "wallpaper.sh --pick"))
hl.bind(mod .. " + SHIFT + C",     sh("hyprpicker -a"))

-- ── Session ────────────────────────────────────────────────────────────────
hl.bind(mod .. " + L",             sh("loginctl lock-session"))
hl.bind(mod .. " + Escape",        qs("session", "toggle"))
hl.bind(mod .. " + N",             qs("notifications", "toggle"))
hl.bind(mod .. " + A",             qs("quicksettings", "toggle"))
hl.bind(mod .. " + SHIFT + R",     sh("hyprctl reload && notify-send -a Hyprland 'Config reloaded'"))

-- ── Windows ────────────────────────────────────────────────────────────────
hl.bind(mod .. " + Q",             hl.dsp.window.close())
hl.bind(mod .. " + F",             hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
hl.bind(mod .. " + M",             hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }))
hl.bind(mod .. " + T",             hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P",             hl.dsp.window.pseudo())
hl.bind(mod .. " + J",             hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + C",             hl.dsp.window.center())

-- focus / move with arrows and hjkl (vim)
local dirs = { left = "left", right = "right", up = "up", down = "down", h = "left", l = "right", k = "up", j = "down" }
for key, dir in pairs(dirs) do
    -- SUPER+L locks and SUPER+J toggles split, so hjkl focus uses ALT
    local focusMod = (#key == 1) and (mod .. " + ALT") or mod
    hl.bind(focusMod .. " + " .. key,           hl.dsp.focus({ direction = dir }))
    hl.bind(mod .. " + SHIFT + " .. key,        hl.dsp.window.move({ direction = dir }))
end

-- resize with SUPER+CTRL+arrows (repeat while held)
hl.bind(mod .. " + CTRL + left",  hl.dsp.window.resize({ x = -40, y = 0,   relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + right", hl.dsp.window.resize({ x = 40,  y = 0,   relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -40, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 40,  relative = true }), { repeating = true })

-- mouse: SUPER+LMB move, SUPER+RMB resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── Workspaces ─────────────────────────────────────────────────────────────
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + mouse_down",   hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",     hl.dsp.focus({ workspace = "e-1" }))

-- scratchpad
hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- ── Screenshots (hyprshot → satty for annotation) ──────────────────────────
local shots = home .. "/Pictures/Screenshots"
hl.bind("Print",           sh("hyprshot -m region --raw | satty --filename - --output-filename " .. shots .. "/shot-$(date +%F_%H-%M-%S).png --copy-command wl-copy --early-exit"))
hl.bind("SHIFT + Print",   sh("hyprshot -m output -m active -o " .. shots))
hl.bind(mod .. " + Print", sh("hyprshot -m window -m active -o " .. shots))

-- ── Hardware keys (work on the lock screen too) ────────────────────────────
-- Changes go through Quickshell so the OSD pops up.
hl.bind("XF86AudioRaiseVolume",  qs("osd", "volumeUp"),       { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  qs("osd", "volumeDown"),     { locked = true, repeating = true })
hl.bind("XF86AudioMute",         qs("osd", "toggleMute"),     { locked = true })
hl.bind("XF86AudioMicMute",      qs("osd", "toggleMicMute"),  { locked = true })
hl.bind("XF86MonBrightnessUp",   qs("osd", "brightnessUp"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", qs("osd", "brightnessDown"), { locked = true, repeating = true })

hl.bind("XF86AudioNext",  sh("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  sh("playerctl previous"),   { locked = true })
hl.bind("XF86AudioPlay",  sh("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", sh("playerctl play-pause"), { locked = true })
