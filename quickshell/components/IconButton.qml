import QtQuick
import qs.services

// Round hover-highlight button with an icon (and optional label).
Rectangle {
    id: root
    property string icon
    property string label: ""
    property bool active: false
    property real iconSize: 18
    property color fg: active ? Theme.primaryFg : Theme.fg
    signal clicked(var mouse)

    implicitHeight: 30
    implicitWidth: label ? row.implicitWidth + 20 : implicitHeight
    radius: height / 2
    color: active ? Theme.primary
         : area.containsMouse ? Theme.alpha(Theme.fg, 0.10) : "transparent"
    Behavior on color { ColorAnimation { duration: Theme.anim } }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6
        Icon { icon: root.icon; size: root.iconSize; color: root.fg; filled: root.active; anchors.verticalCenter: parent.verticalCenter }
        Txt { text: root.label; visible: root.label !== ""; color: root.fg; anchors.verticalCenter: parent.verticalCenter }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: m => root.clicked(m)
    }
}
