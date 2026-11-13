# hypr dots — glass + green

Hyprland 0.55 (Lua) · Quickshell (hand-written shell) · Matugen (colors from wallpaper) · NixOS.

Packages and services live in `/etc/nixos` (`home/dgaillet/hyprland.nix`,
`hosts/laptop-d/configuration.nix`). Everything here is plain files you edit
live: Home Manager symlinks `~/.config/{quickshell,matugen,kitty,rofi}` into this repo.

## Layout

| Path | What |
| --- | --- |
| `hyprland.lua` | entry point, only `require()`s |
| `conf/*.lua` | monitors, env, look, animations, input, rules, binds, autostart |
| `quickshell/` | bar, notifications, OSD, quick settings, session menu (`qs`) |
| `matugen/` | palette templates → hypr, hyprlock, quickshell, kitty, rofi, GTK, Qt |
| `scripts/wallpaper.sh` | set wallpaper (awww) + re-theme everything |
| `wallpapers/` | drop images here (`SUPER+W` to pick) |
| `hypridle.conf`, `hyprlock.conf` | idle → dim 2.5m → lock 5m → off 5.5m → suspend 15m (battery) |

Generated files (`colors.lua`, `*/colors.*`, `quickshell/colors.json`, `state/`) are gitignored.

## Keys

| Keys | Action |
| --- | --- |
| `SUPER+Return` / `E` / `B` | kitty / Thunar / LibreWolf |
| `SUPER+Space` | app launcher (rofi) · `SUPER+Tab` window switcher |
| `SUPER+V` | clipboard history (Shift+Del deletes) |
| `SUPER+W` | pick wallpaper → whole desktop re-themes |
| `SUPER+A` / `SUPER+N` | quick settings / notifications + calendar |
| `SUPER+Escape` | power menu · `SUPER+L` lock |
| `SUPER+Q` | close window · `F` fullscreen · `M` maximize · `T` float · `C` center · `P` pseudo · `J` split |
| `SUPER+arrows` or `SUPER+ALT+hjkl` | focus · `SUPER+SHIFT+arrows/hjkl` move |
| `SUPER+CTRL+arrows` | resize |
| `SUPER+1..0` / `SUPER+SHIFT+1..0` | workspace / move window there |
| `SUPER+S` / `SUPER+SHIFT+S` | scratchpad / send to scratchpad (also 3-finger swipe up) |
| `Print` | region → satty (annotate, copy, save) · `SHIFT+Print` screen · `SUPER+Print` window |
| `SUPER+SHIFT+C` | color picker · `SUPER+SHIFT+R` reload Hyprland |
| 3-finger swipe ←→ | switch workspace |

Quick settings: right-click Wi-Fi tile = network list, right-click Bluetooth = blueman.

## Tweaks

- Glass strength: `conf/look.lua` (`blur.size/passes`, `brightness`) and `quickshell/services/Theme.qml` (`glassAlpha`).
- Which apps are translucent: `conf/rules.lua` (`glass-*` rules).
- Palette style: `MATUGEN_SCHEME=scheme-vibrant scripts/wallpaper.sh <img>` (default `scheme-fidelity`).
- Debug: `hyprctl configerrors`, `qs log`, `journalctl --user -t qs`.

## License

[MIT](LICENSE) for the configuration and the Quickshell code. The image in `wallpapers/` is not covered.
