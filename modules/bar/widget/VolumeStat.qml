import QtQuick
import QtQuick.Layouts
import qs.components
import qs.commons
import Quickshell.Services.Pipewire
import qs.services

RowLayout {
  id: root

  property int style: Settings.bar.volume.style
  function getNameIcon(index) {
    if (index < 10) {
      return "volume_mute"
    } else if (index < 60) {
      return "volume_down"
    } else {
      return "volume_up"
    }
  }
  spacing: ScalerService.s(2)

  IconImage {
    visible: root.style === 1
    path: Pipewire.defaultAudioSink.audio.muted ? "volume/mute.png" : "volume/volume.png"
  }
  IconText {
    visible: root.style === 2
    name: Pipewire.defaultAudioSink.audio.muted ? "volume_off" : root.getNameIcon(Math.round(Pipewire.defaultAudioSink.audio.volume * 100))
    textColor: theme.button.text
  }
  CustomText {
    visible: root.style === 1 && Settings.bar.position === "top" || Settings.bar.position === "bottom"
    name: Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%"
    isBold: true
    size: "small"
  }
}
