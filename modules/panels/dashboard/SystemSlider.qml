import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import qs.services
import qs.components

RowLayout {
  id: root
  property string nameIcon: ""
  property color iconColor: "white"
  property var theme : ThemeService.theme

  property real value: 0.5

  Layout.fillWidth: true
  spacing: 10

  // Icon button (left)
  Rectangle {
    Layout.preferredWidth: 50
    Layout.preferredHeight: 50
    radius: 25
    color: root.iconColor
    border.width: 3
    border.color: theme.button.border

    IconText{
      name: root.nameIcon
      size: "normal"
      anchors.centerIn: parent

    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
    }
  }

  // Slider bar (right)
  Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 50
    radius: 25
    color: theme.primary.background
    border.width: 3
    border.color: theme.button.border

    Rectangle {
      anchors.fill: parent
      anchors.margins: 8
      radius: 17
      color: theme.primary.background

      Rectangle {
        height: parent.height
        width: parent.width * root.value
        radius: parent.radius
        color: theme.button.text
      }
    }
  }
}
