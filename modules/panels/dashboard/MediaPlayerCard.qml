import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick.Controls
import Quickshell.Io
import qs.services
import qs.components

Rectangle {
  id: root
  property var theme : ThemeService.theme

  property var mprisPlayer: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
  property string currentSong: "No song playing"
  property string currentArtist: "Unknown Artist"
  property string albumArt: ""
  property int position: 0
  property int duration: 0

  Layout.fillWidth: true
  Layout.preferredHeight: 220
  Layout.preferredWidth: 350
  radius: 28
  color: theme.primary.background
  border.width: 3
  border.color: theme.button.border

  function formatTime(ms) {
    if (!ms || ms <= 0)
    return "0:00"

    var totalSeconds = Math.floor(ms)
    var minutes = Math.floor(totalSeconds / 60)
    var seconds = totalSeconds % 60

    return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds)
  }

  RowLayout {
    anchors.fill: parent
    anchors.margins: 20
    spacing: 25

    // Album Art (Circular with rotation) - Left Side
    Item {
      Layout.preferredWidth: 160
      Layout.preferredHeight: 160

      // Rotating container
      Item {
        id: rotatingContainer
        anchors.fill: parent

        RotationAnimation on rotation {
          from: 0
          to: 360
          duration: 10000
          loops: Animation.Infinite
          running: root.mprisPlayer.isPlaying
        }

        ClippingRectangle {
          id: albumArtContainer
          anchors.fill: parent
          radius: width / 2
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

    // Track Info & Controls - Right Side
    ColumnLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: 8

      // Song title with marquee
      Item {
        Layout.fillWidth: true
        Layout.preferredHeight: songText.height
        clip: true

        Text {
          id: songText
          text: root.mprisPlayer ? (root.mprisPlayer.trackTitle || "No song playing") : "No song playing"
          font.family: "ComicShannsMono Nerd Font"
          font.pixelSize: 20
          font.bold: true
          color: theme.primary.foreground

          property bool needsMarquee: width > parent.width
          x: 0

          SequentialAnimation on x {
            running: songText.needsMarquee && root.visible
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

      // Artist name
      Text {
        Layout.fillWidth: true
        text: root.mprisPlayer ? (root.mprisPlayer.trackArtist || "Unknown Artist") : "Unknown Artist"
        font.family: "ComicShannsMono Nerd Font"
        font.pixelSize: 14
        color: theme.primary.dim_foreground
        elide: Text.ElideRight
      }

      Item { Layout.fillHeight: true }

      // Controls Row
      RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 48
        spacing: 12

        Item { Layout.fillWidth: true }

        // Previous button
        Rectangle {
          Layout.preferredWidth: 48
          Layout.preferredHeight: 48
          radius: 24
          color: prevArea.containsMouse ? theme.button.text : theme.button.background

          IconText {
            anchors.centerIn: parent
            name: "skip_previous"
            size: "large"
          }

          MouseArea {
            id: prevArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Players.mprisPlayer?.previous()
          }

          Behavior on color { ColorAnimation { duration: 150 } }
        }

        // Play/Pause button
        Rectangle {
          Layout.preferredWidth: 64
          Layout.preferredHeight: 64
          radius: 32
          color: playArea.containsMouse ? theme.button.text : theme.button.background

          IconText {
            anchors.centerIn: parent
            name: Players.mprisPlayer && Players.mprisPlayer.isPlaying ? "pause" : "play_arrow"
            size: "large"
          }

          MouseArea {
            id: playArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Players.mprisPlayer?.togglePlaying()
          }

          Behavior on color { ColorAnimation { duration: 150 } }
        }

        // Next button
        Rectangle {
          Layout.preferredWidth: 48
          Layout.preferredHeight: 48
          radius: 24
          color: nextArea.containsMouse ? theme.button.text : theme.button.background

          IconText {
            anchors.centerIn: parent
            name: "skip_next"
            size: "large"
          }

          MouseArea {
            id: nextArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Players.mprisPlayer?.next()
          }

          Behavior on color { ColorAnimation { duration: 150 } }
        }

        Item { Layout.fillWidth: true }
      }

      // Progress bar with time
      ColumnLayout {
        Layout.fillWidth: true
        spacing: 4
        visible: root.mprisPlayer && root.mprisPlayer.length > 0

        RowLayout {
          Layout.fillWidth: true

          Text {
            text: formatTime(root.mprisPlayer ? root.mprisPlayer.position : 0)
            font.family: "ComicShannsMono Nerd Font"
            font.pixelSize: 11
            color: theme.primary.dim_foreground
          }

          Item { Layout.fillWidth: true }

          Text {
            text: formatTime(root.mprisPlayer ? root.mprisPlayer.length : 0)
            font.family: "ComicShannsMono Nerd Font"
            font.pixelSize: 11
            color: theme.primary.dim_foreground
          }
        }

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight:6
          radius: 3
          color: theme.primary.dim_background

          Rectangle {
            id: progressFill
            height: parent.height
            width: root.mprisPlayer ? Math.min(parent.width, parent.width * (root.mprisPlayer.position / Math.max(1, root.mprisPlayer.length))) : 0
            radius: parent.radius
            color: theme.button.text

            Behavior on width {
              NumberAnimation { duration: 200 }
            }
          }
        }
      }

      Item { Layout.preferredHeight: 5 }
    }
  }
  Timer {
    // only emit the signal when the position is actually changing.
    running: mprisPlayer.playbackState == MprisPlaybackState.Playing
    // Make sure the position updates at least once per second.
    interval: 1000
    repeat: true
    // emit the positionChanged signal every second.
    onTriggered: mprisPlayer.positionChanged()
  }
}
