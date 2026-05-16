import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import "." as Com
import qs.services
import qs.commons

Rectangle {
  id: root

  property var theme: ThemeService.theme

  Layout.preferredWidth: 220
  Layout.preferredHeight: 220
  radius: 28
  color: theme.primary.background
  border.color: theme.button.border
  border.width: 3
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
