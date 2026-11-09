import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.services
import qs.components

Rectangle {
    id: root
    property var player
    implicitHeight: 76
    radius: Theme.radius
    color: Theme.alpha(Theme.primaryContainer, 0.45)

    RowLayout {
        anchors { fill: parent; margins: 10 }
        spacing: 12
        ClippingRectangle {
            implicitWidth: 56; implicitHeight: 56; radius: 10
            color: Theme.surfaceHigh
            Image { anchors.fill: parent; source: root.player ? root.player.trackArtUrl : ""; fillMode: Image.PreserveAspectCrop; asynchronous: true }
            Icon { anchors.centerIn: parent; visible: !root.player || root.player.trackArtUrl === ""; icon: "music_note"; size: 26 }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0
            Txt { text: root.player ? root.player.trackTitle || root.player.identity : ""; font.weight: Font.DemiBold; elide: Text.ElideRight; Layout.fillWidth: true }
            Txt { text: root.player ? root.player.trackArtist : ""; color: Theme.fgDim; font.pixelSize: 11; elide: Text.ElideRight; Layout.fillWidth: true }
        }
        IconButton { icon: "skip_previous"; onClicked: root.player.previous(); visible: root.player && root.player.canGoPrevious }
        IconButton { icon: root.player && root.player.isPlaying ? "pause" : "play_arrow"; active: true; onClicked: root.player.togglePlaying() }
        IconButton { icon: "skip_next"; onClicked: root.player.next(); visible: root.player && root.player.canGoNext }
    }
}
