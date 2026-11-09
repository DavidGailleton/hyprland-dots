-- Autostart. Hyprland runs under UWSM, so everything is started either as a
-- systemd user service or via `uwsm app --` (gets its own scope, clean logs:
-- `journalctl --user -t <app>`).

local scripts = os.getenv("HOME") .. "/.config/hypr/scripts/"

hl.on("hyprland.start", function()
    -- hypridle + hyprpolkitagent are systemd user services (home-manager),
    -- started by graphical-session.target — nothing to do here.

    -- wallpaper daemon, then restore last wallpaper + regenerate colors
    hl.exec_cmd("uwsm app -- awww-daemon")
    hl.exec_cmd(scripts .. "wallpaper.sh --restore")

    -- desktop shell (bar, notifications, OSD, panels)
    hl.exec_cmd("uwsm app -- qs")

    -- clipboard history (text + images)
    hl.exec_cmd("uwsm app -- wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("uwsm app -- wl-paste --type image --watch cliphist store")

    hl.exec_cmd("mkdir -p " .. os.getenv("HOME") .. "/Pictures/Screenshots")
end)
