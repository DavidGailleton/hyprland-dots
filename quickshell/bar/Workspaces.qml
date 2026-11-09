import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.services
import qs.components

// Pills: active = long primary pill, occupied = dot, empty = faint dot.
Row {
    id: root
    property string screenName
    spacing: 4

    readonly property var occupied: {
        const ids = {}
        for (const ws of Hyprland.workspaces.values)
            if (ws.id > 0 && ws.toplevels.values.length > 0) ids[ws.id] = true
        return ids
    }
    readonly property int activeId: {
        const m = Hyprland.monitors.values.find(m => m.name === root.screenName)
        return m && m.activeWorkspace ? m.activeWorkspace.id : 1
    }
    readonly property int count: {
        let max = 5
        for (const ws of Hyprland.workspaces.values) if (ws.id > max) max = ws.id
        return Math.min(max, 10)
    }

    Repeater {
        model: root.count
        Item {
            required property int index
            readonly property int wsId: index + 1
            readonly property bool active: wsId === root.activeId
            readonly property bool used: !!root.occupied[wsId]
            width: active ? 30 : 16
            height: 24
            Behavior on width { NumberAnimation { duration: 260; easing.type: Easing.OutBack; easing.overshoot: 1.6 } }

            Rectangle {
                anchors.centerIn: parent
                width: parent.active ? 26 : (parent.used ? 8 : 6)
                height: parent.active ? 10 : width
                radius: height / 2
                color: parent.active ? Theme.primary
                     : parent.used ? Theme.fgDim : Theme.alpha(Theme.fg, 0.25)
                Behavior on width { NumberAnimation { duration: 260; easing.type: Easing.OutBack; easing.overshoot: 1.6 } }
                Behavior on color { ColorAnimation { duration: Theme.anim } }
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Quickshell.execDetached(["hyprctl", "dispatch", `hl.dsp.focus({ workspace = ${parent.wsId} })`])
            }
        }
    }

    // scroll on the indicator to move between workspaces
    WheelHandler {
        onWheel: e => Quickshell.execDetached(["hyprctl", "dispatch",
            `hl.dsp.focus({ workspace = "${e.angleDelta.y > 0 ? "e-1" : "e+1"}" })`])
    }
}
