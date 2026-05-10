// AlbumArt.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import qs.services

Item {
  id: albumArt
  width: 160
  height: 160

  // Rotating container
  Item {
    id: rotatingContainer
    anchors.fill: parent

    RotationAnimation on rotation {
      from: 0
      to: 360
      duration: 10000
      loops: Animation.Infinite
      running: Players.mprisPlayer?.isPlaying ?? false
    }

    ClippingRectangle {
      id: albumArtContainer
      anchors.fill: parent
      radius: 80
      color: theme.primary.dim_background
      border.color: theme.normal.black
      border.width: 3

      Image {
        id: albumImage
        anchors.fill: parent
        source: Players.getArtUrl(Players.mprisPlayer)
        fillMode: Image.PreserveAspectCrop
        visible: status === Image.Ready
        cache: false
        asynchronous: true
        smooth: true
      }

      // Placeholder when no album art
      Text {
        anchors.centerIn: parent
        text: "No Art"
        font.family: "ComicShannsMono Nerd Font"
        font.pixelSize: 14
        color: theme.primary.dim_foreground
        visible: albumImage.status !== Image.Ready
      }
    }
  }
}
