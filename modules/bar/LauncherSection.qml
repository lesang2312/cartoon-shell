import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Effects
import Quickshell.Io
import qs.services
import qs.commons
import qs.components

Rectangle {
  id: root
  width: ScalerService.s(200)
  height: ScalerService.s(50)
  color: theme.primary.background
  radius: ScalerService.s(Settings.appearance.radius2)
  border.color: theme.button.border
  border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
  property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"
  RowLayout {
    anchors.centerIn: parent
    spacing: ScalerService.s(15)

    ButtonIconImage{
      path: "launcher/dashboard.png"
      size: "large"
      onClicked: VisibleService.togglePanel("launcher");
    }
  }
}
