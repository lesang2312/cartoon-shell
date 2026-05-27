import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
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
    target: Pipewire.defaultAudioSink?.audio ?? null

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
            Image {
              Layout.preferredWidth: ScalerService.s(40)
              Layout.preferredHeight: ScalerService.s(40)
              source: root.getVolumeIcon()
              fillMode: Image.PreserveAspectFit
              smooth: true
            }
            Text {
              text: isMuted ? (lang?.volume?.muted || "Muted") : Math.round(currentVolume * 100) + "%"
              color: theme.primary.foreground
              font.family: "ComicShannsMono Nerd Font"
              font.pixelSize: ScalerService.s(30)
              font.bold: true
            }
            Rectangle {
              color: "transparent"

              Layout.fillWidth: true
              Layout.fillHeight: true
              Text {
                text: " " + (lang?.volume?.title || "Âm thanh")
                anchors.margins: ScalerService.s(10)
                anchors.top: parent.top
                anchors.right: parent.right
                color: theme.primary.foreground
                font.family: "ComicShannsMono Nerd Font"
                font.pixelSize: ScalerService.s(20)
                font.bold: true
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
              color: "#333333"

              Rectangle {
                anchors {
                  left: parent.left
                  top: parent.top
                  bottom: parent.bottom
                }
                width: parent.width * currentVolume
                radius: parent.radius
                color: isMuted ? "#ff6b6b" : "#4a86e8"
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
    return "../../assets/volume/volume_0.png";
    if (currentVolume <= 0.25)
    return "../../assets/volume/volume_1.png";
    if (currentVolume <= 0.50)
    return "../../assets/volume/volume_2.png";
    if (currentVolume <= 0.75)
    return "../../assets/volume/volume_3.png";
    if (currentVolume <= 1)
    return "../../assets/volume/volume_4.png";
    return "../../assets/volume/volume_5.png";
  }
}
