import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import qs.components
import qs.services

Scope {
  id: root

  property var theme: ThemeService.theme
  property var lang: LanguageService.translations
  property bool shouldShowOsd: false
  property real currentVolume: Pipewire.defaultAudioSink?.audio.volume ?? 0
  property bool isMuted: Pipewire.defaultAudioSink?.audio.mute ?? false

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  Connections {
    target: Pipewire.defaultAudioSink.audio ?? null

    function onVolumeChanged() {
      root.shouldShowOsd = true;
      hideTimer.restart();
    }
  }

  Timer {
    id: hideTimer
    interval: 1000
    onTriggered: root.shouldShowOsd = false
  }

  LazyLoader {
    active: root.shouldShowOsd

    PanelWindow {
      anchors {
        bottom: true
      }
      margins {
        bottom: ScalerService.s(120)
      }
      exclusiveZone: 0
      implicitWidth: ScalerService.s(280)
      implicitHeight: ScalerService.s(100)
      color: "transparent"
      mask: Region {}

      Rectangle {
        anchors.fill: parent
        radius: ScalerService.s(15)
        color: theme.primary.background
        border.color: theme.normal.black
        border.width: ScalerService.s(3)

        ColumnLayout {
          anchors {
            fill: parent
            leftMargin: ScalerService.s(15)
            rightMargin: ScalerService.s(15)
            bottomMargin: ScalerService.s(15)
          }
          spacing: ScalerService.s(12)

          RowLayout {
            IconImage {
              path: root.getVolumeIcon()
              size: "large"
            }
            CustomText {
              name: Math.round(currentVolume * 100) + "%"
              color: theme.primary.foreground
              size: "large"
              isBold: true
            }
            Rectangle {
              color: "transparent"

              Layout.fillWidth: true
              Layout.fillHeight: true
              CustomText {
                name: " " + (lang?.volume?.title || "Âm thanh")
                anchors.margins: ScalerService.s(10)
                anchors.top: parent.top
                anchors.right: parent.right
              }
            }
          }

          // Thanh volume
          ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: ScalerService.s(4)

            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: ScalerService.s(20)
              radius: ScalerService.s(20)
              color: theme.primary.dim_background

              Rectangle {
                anchors {
                  left: parent.left
                  top: parent.top
                  bottom: parent.bottom
                }
                width: parent.width * currentVolume
                radius: parent.radius
                color: Pipewire.defaultAudioSink.audio.muted ? theme.primary.dim_foreground : theme.normal.blue
                Behavior on width {
                  NumberAnimation {
                    duration: 200
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  function getVolumeIcon() {
    if (isMuted || currentVolume == 0)
    return "volume/volume_0.png";
    if (currentVolume <= 0.25)
    return "volume/volume_1.png";
    if (currentVolume <= 0.50)
    return "volume/volume_2.png";
    if (currentVolume <= 0.75)
    return "volume/volume_3.png";
    if (currentVolume <= 1)
    return "volume/volume_4.png";
    return "volume/volume_5.png";
  }
}
