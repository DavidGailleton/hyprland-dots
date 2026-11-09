import QtQuick
import qs.services

Text {
    color: Theme.fg
    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    verticalAlignment: Text.AlignVCenter
    renderType: Text.NativeRendering
    Behavior on color { ColorAnimation { duration: Theme.anim } }
}
