pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// Default speaker + mic, with helpers used by the bar, OSD and quick settings.
Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property bool ready: !!sink && !!sink.audio

    readonly property real volume: ready ? sink.audio.volume : 0
    readonly property bool muted: ready ? sink.audio.muted : false
    readonly property bool micMuted: source && source.audio ? source.audio.muted : false

    // bind the nodes so their audio properties are live
    PwObjectTracker { objects: [root.sink, root.source] }

    function setVolume(v) { if (ready) { sink.audio.muted = false; sink.audio.volume = Math.max(0, Math.min(1, v)) } }
    function step(delta) { setVolume(Math.round((volume + delta) * 20) / 20) }
    function toggleMute() { if (ready) sink.audio.muted = !sink.audio.muted }
    function toggleMicMute() { if (source && source.audio) source.audio.muted = !source.audio.muted }

    function icon() {
        if (muted || volume <= 0.001) return "volume_off"
        if (volume < 0.34) return "volume_mute"
        if (volume < 0.67) return "volume_down"
        return "volume_up"
    }
}
