import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.services
import qs.components

// Notification history + calendar. SUPER+N or click the clock.
PanelWindow {
    id: win
    visible: Panels.open === "notifications"
    anchors { top: true; right: true; bottom: true }
    margins { top: Theme.barHeight + 14; right: Theme.gap; bottom: Theme.gap }
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: 400
    color: "transparent"
    WlrLayershell.namespace: "qs-notification-center"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    HyprlandFocusGrab { windows: [win]; active: win.visible; onCleared: Panels.close() }

    Glass {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: Panels.close()

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            // header
            RowLayout {
                Layout.fillWidth: true
                Txt { text: "Notifications"; font.pixelSize: 17; font.weight: Font.Bold; Layout.fillWidth: true }
                IconButton {
                    icon: Notifs.dnd ? "notifications_off" : "notifications_active"
                    active: Notifs.dnd
                    onClicked: Notifs.dnd = !Notifs.dnd
                }
                IconButton { icon: "clear_all"; onClicked: Notifs.dismissAll() }
            }

            // list
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 8
                model: Notifs.list
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
                delegate: NotificationCard {
                    required property var modelData
                    notif: modelData
                    width: ListView.view.width
                }
                add: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 } }
                remove: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 150 } }

                Column {
                    anchors.centerIn: parent
                    visible: Notifs.list.length === 0
                    spacing: 6
                    Icon { icon: "forest"; size: 48; color: Theme.alpha(Theme.primary, 0.6); anchors.horizontalCenter: parent.horizontalCenter }
                    Txt { text: "All quiet"; color: Theme.fgDim; anchors.horizontalCenter: parent.horizontalCenter }
                }
            }

            // calendar
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: cal.implicitHeight + 20
                radius: Theme.radius
                color: Theme.alpha(Theme.fg, 0.06)
                MonthCalendar { id: cal; anchors { fill: parent; margins: 10 } }
            }
        }
    }
}
