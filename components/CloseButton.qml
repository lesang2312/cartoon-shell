import QtQuick
import qs.components

Rectangle {
  id: root
  anchors.right: parent.right
  anchors.verticalCenter: parent.verticalCenter
  implicitWidth: 32
  implicitHeight: 32
  radius: 116
  color: closeArea.containsMouse ? theme.normal.red : theme.button.background
  signal clicked()

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

    onClicked: root.clicked()
  }
}
