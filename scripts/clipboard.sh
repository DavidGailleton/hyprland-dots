#!/usr/bin/env bash
# Clipboard history picker (cliphist + rofi). Shift+Del in rofi deletes an entry.
pkill -x rofi && exit 0
sel="$(cliphist list | rofi -dmenu -i -p "  Clipboard" -display-columns 2 \
        -kb-delete-entry '' -kb-custom-1 'shift+Delete' -mesg 'Enter: paste · Shift+Del: delete')"
code=$?
[[ -z "$sel" ]] && exit 0
if [[ $code -eq 10 ]]; then
    printf '%s' "$sel" | cliphist delete
else
    printf '%s' "$sel" | cliphist decode | wl-copy
fi
