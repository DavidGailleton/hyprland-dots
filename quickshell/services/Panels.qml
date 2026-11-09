pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Which overlay panel is open. Only one at a time.
// Toggle from Hyprland binds: `qs ipc call <target> toggle`.
Singleton {
    id: root
    property string open: ""   // "", "quicksettings", "notifications", "session"
    property bool caffeine: false   // idle inhibitor (held by the bar window)

    function toggle(name) { open = (open === name) ? "" : name }
    function close() { open = "" }

    IpcHandler { target: "quicksettings"; function toggle(): void { root.toggle("quicksettings") } }
    IpcHandler { target: "notifications"; function toggle(): void { root.toggle("notifications") } }
    IpcHandler { target: "session";       function toggle(): void { root.toggle("session") } }
}
