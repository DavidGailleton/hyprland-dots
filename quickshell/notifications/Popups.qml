import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services

// Toasts in the top-right corner, below the bar.
PanelWindow {
    id: win
    visible: Notifs.popups.length > 0 && Panels.open !== "notifications"
    anchors { top: true; right: true }
    margins { top: Theme.barHeight + 14; right: Theme.gap }
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: 380
    implicitHeight: col.implicitHeight
    color: "transparent"
    WlrLayershell.namespace: "qs-notifications"
    WlrLayershell.layer: WlrLayer.Overlay

    Column {
        id: col
        width: parent.width
        spacing: 8
        Repeater {
            model: Notifs.popups
            NotificationCard {
                required property var modelData
                notif: modelData
                popup: true
                width: col.width
                onTimedOut: Notifs.hidePopup(modelData)
                Connections { target: modelData; function onClosed() { Notifs.hidePopup(modelData) } }
            }
        }
    }
}
