pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Backlight via brightnessctl (no root needed: logind handles it).
Singleton {
    id: root

    property real value: 0      // 0..1
    property int max: 1

    function refresh() { reader.running = true }
    function set(v) {
        v = Math.max(0.01, Math.min(1, v))
        root.value = v
        Quickshell.execDetached(["brightnessctl", "-q", "set", Math.round(v * 100) + "%"])
    }
    function step(delta) { set(Math.round((value + delta) * 20) / 20) }

    Process {
        id: reader
        command: ["brightnessctl", "-m", "info"]
        stdout: StdioCollector {
            onStreamFinished: {
                // name,class,current,percent,max
                const f = text.trim().split(",")
                if (f.length >= 5) { root.max = parseInt(f[4]); root.value = parseInt(f[2]) / root.max }
            }
        }
    }
    Component.onCompleted: refresh()
}
