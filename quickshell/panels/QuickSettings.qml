import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.UPower
import Quickshell.Services.Mpris
import qs.services
import qs.components

// SUPER+A or click the status pill.
PanelWindow {
    id: win
    visible: Panels.open === "quicksettings"
    anchors { top: true; right: true }
    margins { top: Theme.barHeight + 14; right: Theme.gap }
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: 380
    implicitHeight: content.implicitHeight + 28
    color: "transparent"
    WlrLayershell.namespace: "qs-quicksettings"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    HyprlandFocusGrab { windows: [win]; active: win.visible; onCleared: Panels.close() }
    onVisibleChanged: if (visible) Brightness.refresh()

    readonly property var wifi: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var wifiNet: wifi ? wifi.networks.values.find(n => n.connected) ?? null : null
    readonly property var bt: Bluetooth.defaultAdapter
    readonly property var btDevices: bt ? bt.devices.values.filter(d => d.connected) : []
    property bool showWifi: false

    function run(cmd) { Panels.close(); Quickshell.execDetached(["sh", "-c", cmd]) }

    Glass {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: Panels.close()

        ColumnLayout {
            id: content
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 14 }
            spacing: 12

            // ── header ──
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                Rectangle {
                    implicitWidth: 38; implicitHeight: 38; radius: 19
                    color: Theme.primaryContainer
                    Icon { anchors.centerIn: parent; icon: "eco"; filled: true; color: Theme.primaryContainerFg; size: 22 }
                }
                ColumnLayout {
                    spacing: 0
                    Layout.fillWidth: true
                    Txt { text: Quickshell.env("USER"); font.weight: Font.Bold; font.pixelSize: 15 }
                    Txt {
                        readonly property var b: UPower.displayDevice
                        visible: b && b.isLaptopBattery
                        text: {
                            if (!b) return ""
                            const p = Math.round((b.percentage > 1 ? b.percentage : b.percentage * 100))
                            const t = b.state === UPowerDeviceState.Charging ? b.timeToFull : b.timeToEmpty
                            const hm = t > 0 ? ` · ${Math.floor(t / 3600)}h${String(Math.floor(t % 3600 / 60)).padStart(2, "0")}` : ""
                            return `${p}% ${b.state === UPowerDeviceState.Charging ? "charging" : "battery"}${hm}`
                        }
                        font.pixelSize: 11
                        color: Theme.fgDim
                    }
                }
                IconButton { icon: "palette"; onClicked: win.run(Quickshell.env("HOME") + "/.config/hypr/scripts/wallpaper.sh --pick") }
                IconButton { icon: "lock"; onClicked: win.run("loginctl lock-session") }
                IconButton { icon: "power_settings_new"; fg: Theme.error; onClicked: Panels.toggle("session") }
            }

            // ── sliders ──
            Slider {
                Layout.fillWidth: true
                icon: Audio.icon()
                value: Audio.muted ? 0 : Audio.volume
                onMoved: v => Audio.setVolume(v)
                onIconClicked: Audio.toggleMute()
            }
            Slider {
                Layout.fillWidth: true
                icon: "light_mode"
                value: Brightness.value
                onMoved: v => Brightness.set(v)
            }

            // ── toggles ──
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 8
                columnSpacing: 8

                Tile {
                    icon: !Networking.wifiEnabled ? "wifi_off" : "wifi"
                    title: "Wi-Fi"
                    subtitle: !Networking.wifiEnabled ? "Off" : win.wifiNet ? win.wifiNet.name : "Not connected"
                    active: Networking.wifiEnabled
                    onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
                    onRightClicked: win.showWifi = !win.showWifi
                }
                Tile {
                    icon: win.btDevices.length > 0 ? "bluetooth_connected" : win.bt && win.bt.enabled ? "bluetooth" : "bluetooth_disabled"
                    title: "Bluetooth"
                    subtitle: !win.bt ? "Unavailable" : !win.bt.enabled ? "Off"
                            : win.btDevices.length === 1 ? win.btDevices[0].name
                            : win.btDevices.length > 1 ? win.btDevices.length + " devices" : "On"
                    active: !!win.bt && win.bt.enabled
                    onClicked: if (win.bt) win.bt.enabled = !win.bt.enabled
                    onRightClicked: win.run("uwsm app -- blueman-manager")
                }
                Tile {
                    readonly property var p: PowerProfiles.profile
                    icon: p === PowerProfile.PowerSaver ? "energy_savings_leaf" : p === PowerProfile.Performance ? "bolt" : "balance"
                    title: "Power"
                    subtitle: p === PowerProfile.PowerSaver ? "Saver" : p === PowerProfile.Performance ? "Performance" : "Balanced"
                    active: p !== PowerProfile.Balanced
                    onClicked: PowerProfiles.profile =
                        p === PowerProfile.PowerSaver ? PowerProfile.Balanced
                        : p === PowerProfile.Balanced && PowerProfiles.hasPerformanceProfile ? PowerProfile.Performance
                        : PowerProfile.PowerSaver
                }
                Tile {
                    icon: Notifs.dnd ? "do_not_disturb_on" : "do_not_disturb_off"
                    title: "Do not disturb"
                    subtitle: Notifs.dnd ? "On" : "Off"
                    active: Notifs.dnd
                    onClicked: Notifs.dnd = !Notifs.dnd
                }
                Tile {
                    icon: "coffee"
                    title: "Caffeine"
                    subtitle: Panels.caffeine ? "Staying awake" : "Off"
                    active: Panels.caffeine
                    onClicked: Panels.caffeine = !Panels.caffeine
                }
                Tile {
                    icon: Audio.micMuted ? "mic_off" : "mic"
                    title: "Microphone"
                    subtitle: Audio.micMuted ? "Muted" : "On"
                    active: !Audio.micMuted
                    onClicked: Audio.toggleMicMute()
                }
            }

            // ── wifi list (right-click the Wi-Fi tile) ──
            ColumnLayout {
                Layout.fillWidth: true
                visible: win.showWifi && !!win.wifi
                spacing: 2
                Txt { text: "Networks"; font.weight: Font.DemiBold; color: Theme.fgDim; Layout.bottomMargin: 2 }
                Repeater {
                    model: win.wifi ? [...win.wifi.networks.values].sort((a, b) => b.signalStrength - a.signalStrength).slice(0, 7) : []
                    Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        implicitHeight: 34
                        radius: Theme.radiusSmall
                        color: na.containsMouse ? Theme.alpha(Theme.fg, 0.10) : "transparent"
                        RowLayout {
                            anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                            spacing: 10
                            Icon { icon: modelData.signalStrength > 0.66 ? "wifi" : modelData.signalStrength > 0.33 ? "wifi_2_bar" : "wifi_1_bar"; color: modelData.connected ? Theme.primary : Theme.fg }
                            Txt { text: modelData.name; Layout.fillWidth: true; elide: Text.ElideRight; color: modelData.connected ? Theme.primary : Theme.fg }
                            Icon { visible: modelData.security !== WifiSecurityType.Open; icon: "lock"; size: 14; color: Theme.fgDim }
                        }
                        MouseArea {
                            id: na
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData.connected) modelData.disconnect()
                                else if (modelData.known || modelData.security === WifiSecurityType.Open) modelData.connect()
                                else win.run("uwsm app -- nm-connection-editor")
                            }
                        }
                    }
                }
            }

            // ── media ──
            MediaCard {
                Layout.fillWidth: true
                player: Mpris.players.values.find(p => p.isPlaying) ?? Mpris.players.values[0] ?? null
                visible: player !== null
            }
        }
    }
}
