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
  CustomText {
    anchors.centerIn: parent

    name: lang.musicPanel?.title || "Music Player"
    isBold: true
    size: "large"
  }

  // Close button (right side)
  CloseButton{
    onClicked: VisibleService.togglePanel("music")
  }
}
