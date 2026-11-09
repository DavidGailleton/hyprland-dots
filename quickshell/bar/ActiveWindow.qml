import QtQuick
import Quickshell.Hyprland
import qs.services
import qs.components

Txt {
    readonly property var win: Hyprland.activeToplevel
    text: win && win.title ? win.title : ""
    color: Theme.fgDim
    elide: Text.ElideRight
    leftPadding: 4
}
