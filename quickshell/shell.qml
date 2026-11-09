//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
import QtQuick
import Quickshell
import qs.bar
import qs.notifications
import qs.osd
import qs.panels

// Desktop shell: bar per screen + overlays. Colors: services/Theme.qml.
// Logs: `journalctl --user -t qs` (started via uwsm) or `qs log`.
ShellRoot {
    Variants {
        model: Quickshell.screens
        Bar {}
    }
    Popups {}
    Center {}
    QuickSettings {}
    Session {}
    Osd {}
}
