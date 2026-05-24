import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
import qs.commons

Rectangle {
  id: flagItem

  property string flagName: ""
  property string displayName: ""
  property bool isSelected: false
  property real animationProgress: 0

  property var theme: ThemeService.theme

  width: 105
  height: 70
  color: isSelected ? theme.button.background_select : theme.primary.dim_background
  border.color: isSelected ? theme.button.border_select : theme.button.border
  radius: Settings.appearance.radius3
  border.width: Settings.appearance.enableBorder ? isSelected ? 2 : 1 : 0

  signal clicked()

  scale: 1.0

  Behavior on scale {
    NumberAnimation { duration: 150 }
  }

  Behavior on border.width {
    NumberAnimation { duration: 150 }
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: 0

    IconImage {
      path: `flags/${flagName}.png`
      size: "xl"
      Layout.alignment: Qt.AlignHCenter

    }

    CustomText {
      name: displayName
      size: "small"
      isBold: isSelected
      Layout.alignment: Qt.AlignHCenter
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: flagItem.clicked()

    onEntered: parent.scale = 1.05
    onExited: parent.scale = 1.0
  }
}
