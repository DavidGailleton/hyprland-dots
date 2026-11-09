import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.components

// Floating glass bar, one per screen.
PanelWindow {
    id: bar
    required property ShellScreen modelData
    screen: modelData

    anchors { top: true; left: true; right: true }
    margins { top: 8; left: Theme.gap; right: Theme.gap }
    implicitHeight: Theme.barHeight
    exclusiveZone: Theme.barHeight + 2
    color: "transparent"

    WlrLayershell.namespace: "qs-bar"
    WlrLayershell.layer: WlrLayer.Top

    // "Caffeine" toggle in quick settings: keep the screen awake
    IdleInhibitor { window: bar; enabled: Panels.caffeine }

    Glass {
        anchors.fill: parent
        radius: Theme.radius

        // ── left ──
        RowLayout {
            anchors { left: parent.left; leftMargin: 6; verticalCenter: parent.verticalCenter }
            spacing: 8
            IconButton {
                icon: "eco"; iconSize: 20
                fg: Theme.primary
                onClicked: Quickshell.execDetached(["sh", "-c", "pkill -x rofi || uwsm app -- rofi -show drun"])
            }
            Workspaces { screenName: bar.modelData.name }
            ActiveWindow { Layout.maximumWidth: bar.width * 0.28 }
        }

        // ── center ──
        Clock { anchors.centerIn: parent }

        // ── right ──
        RowLayout {
            anchors { right: parent.right; rightMargin: 6; verticalCenter: parent.verticalCenter }
            spacing: 6
            Tray { barWindow: bar }
            StatusPill {}
            IconButton {
                icon: "notifications"
                active: Panels.open === "notifications"
                Rectangle {   // unread dot
                    visible: Notifs.list.length > 0 && Panels.open !== "notifications"
                    width: 7; height: 7; radius: 4
                    color: Notifs.dnd ? Theme.outline : Theme.primary
                    anchors { top: parent.top; right: parent.right; margins: 5 }
                }
                onClicked: Panels.toggle("notifications")
            }
            IconButton {
                icon: "power_settings_new"
                fg: Theme.error
                onClicked: Panels.toggle("session")
            }
        }
    }
}
