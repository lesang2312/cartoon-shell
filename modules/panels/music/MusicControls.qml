// MusicControls.qml
import QtQuick
import QtQuick.Layouts
import qs.commons
import qs.components
import qs.services

RowLayout {
  id: controls
  Layout.fillWidth: true
  Layout.preferredHeight: 60
  spacing: 24

  Item { Layout.fillWidth: true }

  // Previous
  Rectangle {
    Layout.preferredWidth: 48
    Layout.preferredHeight: 48
    radius: 24
    color: prevArea.containsMouse ? theme.button.background_select : theme.button.background

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

  // Play/Pause
  Rectangle {
    Layout.preferredWidth: 64
    Layout.preferredHeight: 64
    radius: 32
    color: playArea.containsMouse ? theme.normal.blue : theme.button.background

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

  // Next
  Rectangle {
    Layout.preferredWidth: 48
    Layout.preferredHeight: 48
    radius: 24
    color: nextArea.containsMouse ? theme.button.background_select : theme.button.background

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
