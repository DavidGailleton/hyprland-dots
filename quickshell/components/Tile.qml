import QtQuick
import QtQuick.Layouts
import qs.services

// Quick-settings toggle tile: icon + title + subtitle.
Rectangle {
    id: root
    property string icon
    property string title
    property string subtitle: ""
    property bool active: false
    signal clicked()
    signal rightClicked()

    Layout.fillWidth: true
    implicitHeight: 58
    radius: Theme.radius
    color: active ? Theme.primaryContainer
         : area.containsMouse ? Theme.alpha(Theme.fg, 0.14) : Theme.alpha(Theme.fg, 0.08)
    Behavior on color { ColorAnimation { duration: Theme.anim } }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 12
        spacing: 12
        Icon { icon: root.icon; size: 22; filled: root.active; color: root.active ? Theme.primaryContainerFg : Theme.fg }
        ColumnLayout {
            spacing: 0
            Layout.fillWidth: true
            Txt { text: root.title; font.weight: Font.DemiBold; color: root.active ? Theme.primaryContainerFg : Theme.fg; Layout.fillWidth: true; elide: Text.ElideRight }
            Txt { text: root.subtitle; visible: text !== ""; font.pixelSize: 11; opacity: 0.8; color: root.active ? Theme.primaryContainerFg : Theme.fgDim; Layout.fillWidth: true; elide: Text.ElideRight }
        }
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: m => m.button === Qt.RightButton ? root.rightClicked() : root.clicked()
    }
}
