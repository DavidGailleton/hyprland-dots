import QtQuick
import qs.services

// Material Symbols Rounded glyph by name, e.g. Icon { icon: "wifi" }
Text {
    property string icon: ""
    property bool filled: false
    property real size: 18

    text: icon
    color: Theme.fg
    font.family: Theme.iconFont
    font.pixelSize: size
    font.variableAxes: ({ "FILL": filled ? 1 : 0, "wght": 450, "opsz": 24 })
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    Behavior on color { ColorAnimation { duration: Theme.anim } }
}
