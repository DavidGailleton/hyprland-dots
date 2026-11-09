import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.components

// Full-screen power menu. SUPER+Escape. Arrow keys / Tab + Enter, Esc closes.
PanelWindow {
    id: win
    visible: Panels.open === "session"
    anchors { top: true; bottom: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    color: Theme.alpha(Theme.surface, 0.45)
    WlrLayershell.namespace: "qs-session"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    readonly property var actions: [
        { icon: "lock",               label: "Lock",     cmd: "loginctl lock-session" },
        { icon: "bedtime",            label: "Suspend",  cmd: "systemctl suspend" },
        { icon: "logout",             label: "Log out",  cmd: "uwsm stop" },
        { icon: "restart_alt",        label: "Reboot",   cmd: "systemctl reboot" },
        { icon: "power_settings_new", label: "Shut down", cmd: "systemctl poweroff" },
    ]
    property int current: 0
    onVisibleChanged: current = 0

    function trigger(i) { Panels.close(); Quickshell.execDetached(["sh", "-c", actions[i].cmd]) }

    MouseArea { anchors.fill: parent; onClicked: Panels.close() }

    Item {
        anchors.fill: parent
        focus: win.visible
        Keys.onEscapePressed: Panels.close()
        Keys.onLeftPressed:  win.current = (win.current + win.actions.length - 1) % win.actions.length
        Keys.onRightPressed: win.current = (win.current + 1) % win.actions.length
        Keys.onTabPressed:   win.current = (win.current + 1) % win.actions.length
        Keys.onReturnPressed: win.trigger(win.current)

        RowLayout {
            anchors.centerIn: parent
            spacing: 18
            Repeater {
                model: win.actions
                Glass {
                    id: btn
                    required property var modelData
                    required property int index
                    readonly property bool sel: win.current === index
                    implicitWidth: 130; implicitHeight: 140
                    radius: 28
                    color: sel ? Theme.primaryContainer : Theme.glass(Theme.surface, 0.7)
                    border.color: sel ? Theme.primary : Theme.alpha(Theme.fg, 0.08)
                    scale: sel ? 1.06 : 1.0
                    Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }
                    Behavior on color { ColorAnimation { duration: Theme.anim } }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        Icon { icon: btn.modelData.icon; size: 44; filled: btn.sel; Layout.alignment: Qt.AlignHCenter
                               color: btn.sel ? Theme.primaryContainerFg : (btn.index === 4 ? Theme.error : Theme.fg) }
                        Txt { text: btn.modelData.label; Layout.alignment: Qt.AlignHCenter; font.weight: Font.DemiBold
                              color: btn.sel ? Theme.primaryContainerFg : Theme.fg }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: win.current = btn.index
                        onClicked: win.trigger(btn.index)
                    }
                }
            }
        }
    }
}
