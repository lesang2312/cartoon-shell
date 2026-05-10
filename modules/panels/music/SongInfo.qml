// SongInfo.qml
import QtQuick
import QtQuick.Layouts
import qs.services

ColumnLayout {
  id: songInfo
  Layout.fillWidth: true
  Layout.fillHeight: true
  spacing: 8

  Item {
    Layout.fillHeight: true
  }

  // Song title with marquee effect
  Item {
    Layout.fillWidth: true
    Layout.preferredHeight: songText.height
    clip: true

    Text {
      id: songText
      text: Players.mprisPlayer?.trackTitle ?? "Not Playing"
      font.family: "ComicShannsMono Nerd Font"
      font.pixelSize: 22
      font.bold: true
      color: theme.primary.foreground

      property bool needsMarquee: width > parent.width

      x: 0

      SequentialAnimation on x {
        id: marqueeAnimation
        running: songText.needsMarquee
        loops: Animation.Infinite

        PauseAnimation { duration: 2000 }
        NumberAnimation {
          to: -(songText.width - songText.parent.width)
          duration: Math.max(2000, (songText.width - songText.parent.width) * 20)
          easing.type: Easing.Linear
        }
        PauseAnimation { duration: 2000 }
        NumberAnimation {
          to: 0
          duration: Math.max(2000, (songText.width - songText.parent.width) * 20)
          easing.type: Easing.Linear
        }
      }
    }
  }

  Text {
    text: Players.mprisPlayer?.trackTitle
    font.family: "ComicShannsMono Nerd Font"
    font.pixelSize: 16
    color: theme.primary.dim_foreground
    elide: Text.ElideRight
    Layout.fillWidth: true
  }

  // Progress bar

  Item {
    Layout.fillHeight: true
  }

}
