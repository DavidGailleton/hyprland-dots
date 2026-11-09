pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// Notification daemon. `popups` = currently shown toasts, `list` = history.
Singleton {
    id: root

    property bool dnd: false
    property list<QtObject> popups: []
    readonly property var list: server.trackedNotifications.values

    function dismissAll() { for (const n of [...list]) n.dismiss() }
    function hidePopup(n) { popups = popups.filter(p => p !== n) }

    NotificationServer {
        id: server
        keepOnReload: true
        persistenceSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: n => {
            n.tracked = true
            if (!root.dnd || n.urgency === NotificationUrgency.Critical)
                root.popups = [n, ...root.popups].slice(0, 5)
        }
    }
}
