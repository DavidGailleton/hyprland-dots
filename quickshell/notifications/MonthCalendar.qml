import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services
import qs.components

// Month grid, Monday first. Scroll or arrows change month.
ColumnLayout {
    id: root
    property date shown: new Date()
    readonly property date today: new Date()
    spacing: 6

    RowLayout {
        Layout.fillWidth: true
        Txt {
            text: root.shown.toLocaleDateString(Qt.locale("en_GB"), "MMMM yyyy")
            font.weight: Font.DemiBold
            Layout.fillWidth: true
            leftPadding: 6
        }
        IconButton { icon: "chevron_left";  implicitHeight: 26; onClicked: root.shown = new Date(root.shown.getFullYear(), root.shown.getMonth() - 1, 1) }
        IconButton { icon: "today";         implicitHeight: 26; onClicked: root.shown = new Date() }
        IconButton { icon: "chevron_right"; implicitHeight: 26; onClicked: root.shown = new Date(root.shown.getFullYear(), root.shown.getMonth() + 1, 1) }
    }

    DayOfWeekRow {
        Layout.fillWidth: true
        locale: Qt.locale("en_GB")
        delegate: Txt { text: shortName.slice(0, 2); horizontalAlignment: Text.AlignHCenter; font.pixelSize: 11; color: Theme.fgDim; required property string shortName }
    }

    MonthGrid {
        id: grid
        Layout.fillWidth: true
        Layout.preferredHeight: 6 * 30
        month: root.shown.getMonth()
        year: root.shown.getFullYear()
        locale: Qt.locale("en_GB")
        delegate: Item {
            required property var model
            implicitHeight: 30
            implicitWidth: 30
            readonly property bool isToday: model.day === root.today.getDate() && model.month === root.today.getMonth() && model.year === root.today.getFullYear()
            Rectangle {
                anchors.centerIn: parent
                width: 28; height: 28; radius: 14
                color: parent.isToday ? Theme.primary : "transparent"
            }
            Txt {
                anchors.centerIn: parent
                text: parent.model.day
                font.pixelSize: 12
                font.weight: parent.isToday ? Font.Bold : Font.Normal
                color: parent.isToday ? Theme.primaryFg : Theme.fg
                opacity: parent.model.month === grid.month ? 1 : 0.35
            }
        }
    }

    WheelHandler {
        onWheel: e => root.shown = new Date(root.shown.getFullYear(), root.shown.getMonth() + (e.angleDelta.y > 0 ? -1 : 1), 1)
    }
}
