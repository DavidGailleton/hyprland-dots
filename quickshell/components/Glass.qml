import QtQuick
import qs.services

// Translucent rounded panel. Blur comes from Hyprland (layer rule "qs-*").
Rectangle {
    radius: Theme.radius
    color: Theme.glass(Theme.surface)
    border.width: 1
    border.color: Theme.alpha(Theme.fg, 0.08)
    Behavior on color { ColorAnimation { duration: 400 } }
}
