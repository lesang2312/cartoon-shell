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
  id: root

  // Music data
  property int position: 0
  property int duration: 0

  property var theme : ThemeService.theme
  property var lang: LanguageService.translations

  property real animationProgress: 0
  SequentialAnimation on animationProgress {
    running: true

    NumberAnimation {
      from: 0
      to: 2
      duration: 1000
      easing.type: Easing.Linear
    }
  }

  implicitWidth: root.animationProgress > 0.1 ?  500 : 100
  implicitHeight: root.animationProgress > 0.1 ?  500 : 100
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
    radius: Settings.appearance.radius1
    border.width: Settings.appearance.enableBorder ? 3 : 0
    color: theme.primary.background
    border.color: theme.button.border

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 20
      spacing: 16

      // Header
      Com.MusicHeader {
        animationProgress : root.animationProgress
      }

      // Album art and info section
      RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 180
        spacing: 20

        // Album art
        Com.AlbumArt {
          animationProgress : root.animationProgress
        }

        // Song info
        Com.SongInfo {
          animationProgress : root.animationProgress
        }
      }

      // Controls
      Com.MusicControls {
        animationProgress : root.animationProgress
      }
      Com.MusicProgressBar{
        animationProgress : root.animationProgress
      }

      // Cava Visualizer
      Com.CavaVisualizer {
        cavaService: cavaService
        animationProgress : root.animationProgress
      }
    }
  }
}
