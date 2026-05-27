import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import "." as Com
import qs.services
import qs.commons

Rectangle {
  id: root

  Layout.preferredWidth: ScalerService.s(220)
  Layout.preferredHeight: ScalerService.s(220)
  color: theme.primary.background
  border.color: theme.button.border
  radius: ScalerService.s(Settings.appearance.radius1)
  border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
  property real animationProgress: 0

  GridLayout {
    anchors.fill: parent
    anchors.margins: ScalerService.s(20)
    columns: 3
    rows: 3
    columnSpacing: ScalerService.s(15)
    rowSpacing: ScalerService.s(15)

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
