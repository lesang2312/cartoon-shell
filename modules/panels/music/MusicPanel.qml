import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.services
import qs.commons
import qs.components
import "." as Com

PanelWindow {
  id: musicPanel

  // Music data
  property int position: 0
  property int duration: 0

  property var theme : ThemeService.theme
  property var lang: LanguageService.translations

  property real animationProgress: 0
  SequentialAnimation on animationProgress {
    id: staggerAnimation
    running: true
    loops: 1

    PropertyAction { value: 0 }

    NumberAnimation { to: 0.2; duration: 50 }
    NumberAnimation { to: 0.4; duration: 100 }
    NumberAnimation { to: 0.5; duration: 50 }
    NumberAnimation { to: 0.6; duration: 50 }
    NumberAnimation { to: 0.7; duration: 50 }
    NumberAnimation { to: 0.8; duration: 50 }
    NumberAnimation { to: 0.9; duration: 50 }
    NumberAnimation { to: 1; duration: 50 }
    NumberAnimation { to: 1.1; duration: 50 }
  }

  implicitWidth: musicPanel.animationProgress > 0.1 ?  500 : 100
  implicitHeight: musicPanel.animationProgress > 0.1 ?  500 : 100
  Behavior on implicitHeight {
    NumberAnimation {
      duration: 60
      easing.type: Easing.OutCubic
    }
  }
  Behavior on implicitWidth {
    NumberAnimation {
      duration: 60
      easing.type: Easing.OutCubic
    }
  }
  focusable: true

  anchors {
    top: Settings.bar.position === "top"
    bottom: Settings.bar.position === "bottom"
    left: Settings.bar.position === "top" || Settings.bar.position === "bottom" || Settings.bar.position === "left"
    right: Settings.bar.position === "right"
  }

  margins {
    top: Settings.bar.position === "top" ? 10 : 0
    bottom: Settings.bar.position === "bottom" ? 10 : 0
    left: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? 400 : 10
    right: Settings.bar.position === "right" ? 10 : 0
  }

  exclusiveZone: 0
  color: "transparent"

  // CavaService instance
  CavaService {
    id: cavaService
  }

  // Start cava when panel opens
  onVisibleChanged: {
    if (visible) {
      cavaService.open();
    } else {
      cavaService.close();
    }
  }

  // Main content
  Rectangle {
    anchors.fill: parent
    radius: 16
    color: theme.primary.background
    border.color: theme.button.border
    border.width: 3

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 20
      spacing: 16

      // Header
      Com.MusicHeader {
        opacity: musicPanel.animationProgress > 0.5 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }

      // Album art and info section
      RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 180
        spacing: 20

        // Album art
        Com.AlbumArt {
          opacity: musicPanel.animationProgress > 0.6 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }

        // Song info
        Com.SongInfo {
          opacity: musicPanel.animationProgress > 0.7 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }

      // Controls
      Com.MusicControls {
        opacity: musicPanel.animationProgress > 0.8 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }
      Com.MusicProgressBar{
        opacity: musicPanel.animationProgress > 0.9 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }

      }

      // Cava Visualizer
      Com.CavaVisualizer {
        cavaService: cavaService
        opacity: musicPanel.animationProgress > 1 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }
    }
  }
}
