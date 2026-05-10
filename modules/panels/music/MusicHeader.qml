// MusicHeader.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.commons
import qs.components
import qs.services

Item {
  id: header
  Layout.fillWidth: true
  Layout.preferredHeight: 50

  // Title centered
  Row {
    anchors.centerIn: parent
    spacing: 12

    IconImage{
      path: "music/logo_music.png"
      size: "large"
    }

    CustomText {
      name: lang.musicPanel?.title || "Music Player"
      isBold: true
      size: "large"
    }
  }

  // Close button (right side)
  Rectangle {
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 32
    height: 32
    radius: 8
    color: closeArea.containsMouse ? theme.normal.red : theme.button.background

    IconText {
      name: "close"
      size: "normal"
      anchors.centerIn: parent
    }
    MouseArea {
      id: closeArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: VisibleService.togglePanel("music")
    }
  }
}
