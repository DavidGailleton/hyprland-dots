pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Design tokens. Colors are live-loaded from colors.json (written by matugen,
// see scripts/wallpaper.sh) — changing the wallpaper recolors without restart.
Singleton {
    id: root

    property var c: ({})
    function pick(name, fallback) { return c[name] !== undefined ? c[name] : fallback }

    // ── palette (fallback = forest green) ──
    readonly property color primary:            pick("primary", "#85db6b")
    readonly property color primaryFg:          pick("on_primary", "#073900")
    readonly property color primaryContainer:   pick("primary_container", "#5bae44")
    readonly property color primaryContainerFg: pick("on_primary_container", "#ffffff")
    readonly property color secondary:          pick("secondary", "#bccbb0")
    readonly property color secondaryContainer: pick("secondary_container", "#3d4b35")
    readonly property color secondaryContainerFg: pick("on_secondary_container", "#d8e7cb")
    readonly property color surface:            pick("surface", "#10150d")
    readonly property color surfaceLow:         pick("surface_container_low", "#181d15")
    readonly property color surfaceMid:         pick("surface_container", "#1c2119")
    readonly property color surfaceHigh:        pick("surface_container_high", "#262b23")
    readonly property color surfaceHighest:     pick("surface_container_highest", "#31362d")
    readonly property color fg:          pick("on_surface", "#dfe4d7")
    readonly property color fgDim:   pick("on_surface_variant", "#c2c8bb")
    readonly property color outline:            pick("outline", "#8c9387")
    readonly property color outlineVariant:     pick("outline_variant", "#42493f")
    readonly property color error:              pick("error", "#ffb4ab")
    readonly property color errorContainer:     pick("error_container", "#93000a")
    readonly property string wallpaper:         pick("wallpaper", "")

    // ── glass ──
    // panels are translucent; Hyprland blurs behind every "qs-*" layer
    // (conf/rules.lua). Keep alpha > 0.3 (the layer rule's ignore_alpha).
    readonly property real glassAlpha: 0.62
    function glass(col, a) { return Qt.rgba(col.r, col.g, col.b, a === undefined ? glassAlpha : a) }
    function alpha(col, a) { return Qt.rgba(col.r, col.g, col.b, a) }

    // ── shape & type ──
    readonly property int radius: 14
    readonly property int radiusSmall: 10
    readonly property int gap: 12          // matches Hyprland gaps_out
    readonly property int pad: 10
    readonly property int barHeight: 40
    readonly property string font: "Inter"
    readonly property string mono: "JetBrainsMono Nerd Font"
    readonly property string iconFont: "Material Symbols Rounded"
    readonly property int fontSize: 13
    readonly property int anim: 220

    FileView {
        path: Quickshell.shellPath("colors.json")
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try { root.c = JSON.parse(text()) }
            catch (e) { console.warn("Theme: bad colors.json", e) }
        }
    }
}
