// MusicPanel.qml (Main file)
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

  implicitWidth: 500
  implicitHeight: 500
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
      }

      // Album art and info section
      RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 180
        spacing: 20

        // Album art
        Com.AlbumArt {
        }

        // Song info
        Com.SongInfo {
        }
      }

      // Controls
      Com.MusicControls {
      }
      Com.MusicProgressBar{

      }

      // Cava Visualizer
      Com.CavaVisualizer {
        cavaService: cavaService
      }
    }
  }
}
