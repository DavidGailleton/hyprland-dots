#!/usr/bin/env bash
# Set wallpaper (awww, animated) and re-theme everything (matugen).
#   wallpaper.sh <image>     set this image
#   wallpaper.sh --pick      choose from ~/.config/hypr/wallpapers with rofi
#   wallpaper.sh --restore   re-apply the last one (used at login)
set -euo pipefail

DOTS="$HOME/.config/hypr"
WALLS="$DOTS/wallpapers"
STATE="$DOTS/state/wallpaper"
mkdir -p "$(dirname "$STATE")"

# Matugen knobs: fidelity keeps the wallpaper's real chroma (intense greens),
# "prefer saturation" picks the most vivid dominant color without prompting.
SCHEME="${MATUGEN_SCHEME:-scheme-fidelity}"

list_walls() { find -L "$WALLS" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) | sort; }

pick() {
    list_walls | while read -r f; do printf '%s\0icon\x1f%s\n' "$(basename "$f")" "$f"; done \
        | rofi -dmenu -i -p "  Wallpaper" -show-icons \
               -theme-str 'element-icon { size: 64px; } window { width: 46%; }' \
        | { read -r name && printf '%s/%s' "$WALLS" "$name"; }
}

case "${1:-}" in
    --pick)    img="$(pick)" || exit 0 ;;
    --restore) img="$(cat "$STATE" 2>/dev/null || true)"
               [[ -f "$img" ]] || img="$(list_walls | head -n1)" ;;
    "")        echo "usage: $0 <image>|--pick|--restore" >&2; exit 1 ;;
    *)         img="$(realpath "$1")" ;;
esac
[[ -n "${img:-}" && -f "$img" ]] || { notify-send -a Wallpaper "No wallpaper found" "Put images in $WALLS"; exit 1; }

# daemon may still be starting at login
for _ in $(seq 1 20); do awww query >/dev/null 2>&1 && break; sleep 0.1; done

# grow from the cursor position (falls back to center)
pos="$(hyprctl cursorpos 2>/dev/null | tr -d ' ' || echo center)"
awww img "$img" \
    --transition-type grow --transition-pos "${pos:-center}" --invert-y \
    --transition-duration 1.4 --transition-fps 60 --transition-bezier .43,1.19,1,.4

echo "$img" > "$STATE"

matugen image "$img" -c "$DOTS/matugen/config.toml" -m dark -t "$SCHEME" --prefer saturation --source-color-index 0 -q
