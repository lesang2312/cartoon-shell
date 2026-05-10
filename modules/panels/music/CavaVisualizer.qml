// CavaVisualizer.qml
import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
  id: visualizer
  Layout.fillWidth: true
  Layout.fillHeight: true
  Layout.minimumHeight: 100
  radius: 12
  color: theme.primary.dim_background
  clip: true

  property var cavaService: null

  Row {
    id: cavaRow
    anchors.fill: parent
    anchors.margins: 8
    spacing: 2

    Repeater {
      model: cavaService?.values.length ?? 0

      Rectangle {
        width: cavaService && cavaService.values.length > 0
        ? (cavaRow.width - (cavaService.values.length - 1) * 2) / cavaService.values.length
        : 0
        height: cavaService ? Math.max(4, (cavaService.values[index] / 100) * cavaRow.height) : 0
        anchors.bottom: parent.bottom
        radius: 2
        color: {
          if (!cavaService) return theme.normal.blue;
          var ratio = cavaService.values[index] / 100;
          if (ratio < 0.3) return theme.normal.blue;
          if (ratio < 0.5) return theme.normal.cyan;
          if (ratio < 0.7) return theme.normal.green;
          if (ratio < 0.85) return theme.normal.yellow;
          return theme.normal.red;
        }

        Behavior on height { NumberAnimation { duration: 50 } }
        Behavior on color { ColorAnimation { duration: 100 } }
      }
    }
  }

  // No music playing overlay
  Rectangle {
    anchors.fill: parent
    color: theme.primary.dim_background
    opacity: 0.8
    visible: !cavaService?.isRunning || !Players.mprisPlayer?.isPlaying

    Text {
      anchors.centerIn: parent
      text: !Players.mprisPlayer?.isPlaying
      ? (lang.musicPanel?.notPlaying || "Not playing")
      : (lang.musicPanel?.loading || "Loading...")
      font.family: "ComicShannsMono Nerd Font"
      font.pixelSize: 14
      color: theme.primary.dim_foreground
    }
  }
}
