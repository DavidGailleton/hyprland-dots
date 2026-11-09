import QtQuick
import Quickshell
import qs.services
import qs.components

Rectangle {
    id: root
    implicitWidth: row.implicitWidth + 24
    implicitHeight: 30
    radius: height / 2
    color: area.containsMouse ? Theme.alpha(Theme.fg, 0.10) : "transparent"
    Behavior on color { ColorAnimation { duration: Theme.anim } }

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 8
        Txt { text: Qt.formatDateTime(clock.date, "HH:mm"); font.weight: Font.Bold; font.pixelSize: 14 }
        Rectangle { width: 4; height: 4; radius: 2; color: Theme.primary; anchors.verticalCenter: parent.verticalCenter }
        Txt { text: Qt.formatDateTime(clock.date, "ddd d MMM"); color: Theme.fgDim }
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Panels.toggle("notifications")
    }
}
