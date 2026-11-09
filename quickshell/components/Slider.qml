import QtQuick
import qs.services

// Thick rounded slider with an icon inside, like Material 3 expressive.
Item {
    id: root
    property real value: 0          // 0..1
    property string icon: ""
    signal moved(real value)
    signal iconClicked()

    implicitHeight: 34
    implicitWidth: 240

    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: Theme.alpha(Theme.fg, 0.10)

        Rectangle {
            width: Math.max(parent.height, parent.width * root.value)
            height: parent.height
            radius: height / 2
            color: Theme.primary
            Behavior on width { NumberAnimation { duration: 90 } }
        }
    }
    Icon {
        icon: root.icon
        size: 18
        color: root.value > 0.08 ? Theme.primaryFg : Theme.fg
        anchors.verticalCenter: parent.verticalCenter
        x: 9
        MouseArea { anchors.fill: parent; anchors.margins: -6; cursorShape: Qt.PointingHandCursor; onClicked: root.iconClicked() }
    }
    MouseArea {
        anchors.fill: parent
        anchors.leftMargin: 34
        cursorShape: Qt.PointingHandCursor
        function upd(m) { root.moved(Math.max(0, Math.min(1, (m.x + 34) / root.width))) }
        onPressed: m => upd(m)
        onPositionChanged: m => { if (pressed) upd(m) }
        onWheel: w => root.moved(Math.max(0, Math.min(1, root.value + (w.angleDelta.y > 0 ? 0.05 : -0.05))))
    }
}
