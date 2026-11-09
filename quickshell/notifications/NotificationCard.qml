import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.services
import qs.components

// One notification. `popup: true` adds auto-expiry (hover pauses it).
Rectangle {
    id: card
    required property var notif
    property bool popup: false
    signal timedOut()

    readonly property bool critical: notif.urgency === NotificationUrgency.Critical
    implicitHeight: body.implicitHeight + 24
    radius: Theme.radius
    color: popup ? Theme.glass(Theme.surface, 0.72) : Theme.alpha(Theme.fg, 0.06)
    border.width: 1
    border.color: critical ? Theme.error : Theme.alpha(Theme.fg, popup ? 0.10 : 0.0)

    Timer {
        running: card.popup && !hover.hovered && !card.critical
        interval: card.notif.expireTimeout > 0 ? card.notif.expireTimeout : 5000
        onTriggered: card.timedOut()
    }
    HoverHandler { id: hover }

    RowLayout {
        id: body
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
        spacing: 12

        // image or app icon
        ClippingRectangle {
            Layout.alignment: Qt.AlignTop
            implicitWidth: 40; implicitHeight: 40
            radius: 10
            color: Theme.primaryContainer
            IconImage {
                anchors.fill: parent
                visible: source != ""
                source: card.notif.image !== "" ? card.notif.image
                      : card.notif.appIcon !== "" ? Quickshell.iconPath(card.notif.appIcon, true) : ""
            }
            Icon {
                anchors.centerIn: parent
                visible: card.notif.image === "" && card.notif.appIcon === ""
                icon: card.critical ? "priority_high" : "notifications"
                color: Theme.primaryContainerFg
                filled: true
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3
            RowLayout {
                Layout.fillWidth: true
                Txt { text: card.notif.appName || "Notification"; font.pixelSize: 11; color: Theme.primary; font.weight: Font.DemiBold }
                Item { Layout.fillWidth: true }
                Icon {
                    icon: "close"; size: 16; color: Theme.fgDim
                    MouseArea { anchors.fill: parent; anchors.margins: -4; cursorShape: Qt.PointingHandCursor; onClicked: card.notif.dismiss() }
                }
            }
            Txt {
                Layout.fillWidth: true
                text: card.notif.summary
                font.weight: Font.DemiBold
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }
            Txt {
                Layout.fillWidth: true
                visible: text !== ""
                text: card.notif.body
                textFormat: Text.StyledText
                color: Theme.fgDim
                wrapMode: Text.Wrap
                maximumLineCount: card.popup ? 4 : 8
                elide: Text.ElideRight
                onLinkActivated: l => Qt.openUrlExternally(l)
            }
            Flow {
                Layout.fillWidth: true
                Layout.topMargin: 4
                spacing: 6
                visible: card.notif.actions.length > 0
                Repeater {
                    model: card.notif.actions
                    IconButton {
                        required property var modelData
                        icon: "arrow_forward"; iconSize: 14
                        label: modelData.text
                        color: Theme.alpha(Theme.primary, 0.18)
                        onClicked: modelData.invoke()
                    }
                }
            }
        }
    }

    // click the card body = default action (if any) and dismiss
    TapHandler {
        onTapped: {
            const def = card.notif.actions.find(a => a.identifier === "default")
            if (def) def.invoke()
            else if (card.popup) card.timedOut()
        }
    }
}
