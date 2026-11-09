import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.services

Row {
    id: root
    required property var barWindow
    spacing: 2
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items
        Rectangle {
            required property SystemTrayItem modelData
            width: 28; height: 28; radius: 14
            color: area.containsMouse ? Theme.alpha(Theme.fg, 0.10) : "transparent"
            IconImage {
                anchors.centerIn: parent
                implicitSize: 17
                source: parent.modelData.icon
            }
            MouseArea {
                id: area
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onClicked: m => {
                    const it = parent.modelData
                    if (m.button === Qt.LeftButton && !it.onlyMenu) it.activate()
                    else if (m.button === Qt.MiddleButton) it.secondaryActivate()
                    else if (it.hasMenu) {
                        const p = root.barWindow.itemPosition(parent)
                        it.display(root.barWindow, p.x, p.y + parent.height + 6)
                    }
                }
                onWheel: w => parent.modelData.scroll(w.angleDelta.y, false)
            }
        }
    }
}
