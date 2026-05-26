import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import "." as Com
import qs.services
import qs.commons

Rectangle {
  id: root

  Layout.preferredWidth: 220
  Layout.preferredHeight: 220
  color: theme.primary.background
  border.color: theme.button.border
  radius: Settings.appearance.radius1
  border.width: Settings.appearance.enableBorder ? 3 : 0
  property real animationProgress: 0

  GridLayout {
    anchors.fill: parent
    anchors.margins: 20
    columns: 3
    rows: 3
    columnSpacing: 15
    rowSpacing: 15

    Repeater {
      model: Settings.dashboard.appGrid

      Com.AppIcon {
        iconSource: modelData.name
        bgColor: theme.button.background
        animationProgress: root.animationProgress
        revealThreshold: 0.5 + (index * 0.1)
      }
    }
  }
}
