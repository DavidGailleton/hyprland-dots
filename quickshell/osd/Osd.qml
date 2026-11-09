import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.services
import qs.components

// Volume / brightness popup. Driven by Hyprland media keys:
//   qs ipc call osd volumeUp | volumeDown | toggleMute | toggleMicMute | brightnessUp | brightnessDown
Scope {
    id: root
    property string kind: "volume"   // volume | brightness | mic
    property bool shown: false

    function show(k) { kind = k; shown = true; hideTimer.restart() }

    IpcHandler {
        target: "osd"
        function volumeUp(): void       { Audio.step(0.05);  root.show("volume") }
        function volumeDown(): void     { Audio.step(-0.05); root.show("volume") }
        function toggleMute(): void     { Audio.toggleMute(); root.show("volume") }
        function toggleMicMute(): void  { Audio.toggleMicMute(); root.show("mic") }
        function brightnessUp(): void   { Brightness.step(0.05);  root.show("brightness") }
        function brightnessDown(): void { Brightness.step(-0.05); root.show("brightness") }
    }

    Timer { id: hideTimer; interval: 1400; onTriggered: root.shown = false }

    LazyLoader {
        active: root.shown
        PanelWindow {
            anchors.bottom: true
            margins.bottom: 70
            exclusionMode: ExclusionMode.Ignore
            implicitWidth: 300
            implicitHeight: 54
            color: "transparent"
            WlrLayershell.namespace: "qs-osd"
            WlrLayershell.layer: WlrLayer.Overlay
            mask: Region {}   // click-through

            Glass {
                anchors.fill: parent
                radius: height / 2
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 18
                    anchors.rightMargin: 18
                    spacing: 14

                    readonly property real value: root.kind === "brightness" ? Brightness.value
                                                : root.kind === "mic" ? (Audio.micMuted ? 0 : 1)
                                                : (Audio.muted ? 0 : Audio.volume)
                    Icon {
                        size: 22
                        filled: true
                        color: Theme.primary
                        icon: root.kind === "brightness" ? "light_mode"
                            : root.kind === "mic" ? (Audio.micMuted ? "mic_off" : "mic")
                            : Audio.icon()
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 8
                        radius: 4
                        color: Theme.alpha(Theme.fg, 0.15)
                        Rectangle {
                            width: parent.width * Math.min(1, parent.parent.value)
                            height: parent.height
                            radius: 4
                            color: Theme.primary
                            Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                        }
                    }
                    Txt {
                        text: root.kind === "mic" ? (Audio.micMuted ? "Off" : "On") : Math.round(parent.value * 100)
                        font.weight: Font.DemiBold
                        font.features: { "tnum": 1 }
                        Layout.minimumWidth: 30
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        }
    }
}
