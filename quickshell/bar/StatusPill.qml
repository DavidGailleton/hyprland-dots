import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.UPower
import qs.services
import qs.components

// Network · Bluetooth · Volume · Battery — click opens quick settings,
// scroll changes volume.
Rectangle {
    id: root
    implicitWidth: row.implicitWidth + 22
    implicitHeight: 30
    radius: height / 2
    color: Panels.open === "quicksettings" ? Theme.alpha(Theme.primary, 0.22)
         : area.containsMouse ? Theme.alpha(Theme.fg, 0.10) : Theme.alpha(Theme.fg, 0.05)
    Behavior on color { ColorAnimation { duration: Theme.anim } }

    // ── network ──
    readonly property var wifi: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var wired: Networking.devices.values.find(d => d.type === DeviceType.Wired && d.connected) ?? null
    readonly property var wifiNet: wifi ? wifi.networks.values.find(n => n.connected) ?? null : null
    readonly property string netIcon: {
        if (wired) return "lan"
        if (!Networking.wifiEnabled) return "wifi_off"
        if (!wifiNet) return "signal_wifi_statusbar_not_connected"
        const s = wifiNet.signalStrength > 1 ? wifiNet.signalStrength / 100 : wifiNet.signalStrength
        return s > 0.66 ? "wifi" : s > 0.33 ? "wifi_2_bar" : "wifi_1_bar"
    }

    // ── bluetooth ──
    readonly property var bt: Bluetooth.defaultAdapter
    readonly property int btConnected: bt ? bt.devices.values.filter(d => d.connected).length : 0

    // ── battery ──
    readonly property var bat: UPower.displayDevice
    readonly property bool hasBat: bat && bat.ready && bat.isLaptopBattery
    readonly property real pct: !hasBat ? 0 : (bat.percentage > 1 ? bat.percentage / 100 : bat.percentage)
    readonly property bool charging: hasBat && (bat.state === UPowerDeviceState.Charging || bat.state === UPowerDeviceState.FullyCharged || bat.state === UPowerDeviceState.PendingCharge)
    readonly property string batIcon: {
        if (charging) return "battery_charging_full"
        if (pct > 0.95) return "battery_full"
        return "battery_" + Math.max(0, Math.min(6, Math.floor(pct * 7))) + "_bar"
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 10

        Icon { icon: root.netIcon; anchors.verticalCenter: parent.verticalCenter }
        Icon {
            visible: root.bt && root.bt.enabled
            icon: root.btConnected > 0 ? "bluetooth_connected" : "bluetooth"
            color: root.btConnected > 0 ? Theme.primary : Theme.fg
            anchors.verticalCenter: parent.verticalCenter
        }
        Icon {
            icon: Audio.icon()
            color: Audio.muted ? Theme.outline : Theme.fg
            anchors.verticalCenter: parent.verticalCenter
        }
        Row {
            visible: root.hasBat
            spacing: 3
            anchors.verticalCenter: parent.verticalCenter
            Icon {
                icon: root.batIcon
                rotation: 90
                filled: true
                color: root.charging ? Theme.primary : root.pct < 0.15 ? Theme.error : Theme.fg
                anchors.verticalCenter: parent.verticalCenter
            }
            Txt {
                text: Math.round(root.pct * 100) + "%"
                font.pixelSize: 12
                font.weight: Font.Medium
                color: root.pct < 0.15 && !root.charging ? Theme.error : Theme.fg
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Panels.toggle("quicksettings")
        onWheel: w => Audio.step(w.angleDelta.y > 0 ? 0.05 : -0.05)
    }
}
