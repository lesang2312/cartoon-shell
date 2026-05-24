import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
  id: root

  property string panelName: ""

  color: "transparent"
  radius: 6

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: VisibleService.togglePanel(root.panelName)
    onEntered: root.opacity = 0.8
    onExited: root.opacity = 1.0
  }

  Behavior on opacity {
    NumberAnimation {
      duration: 100
    }
  }
}
