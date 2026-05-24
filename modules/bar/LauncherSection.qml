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
  width: 200
  height: 50
  color: theme.primary.background
  radius: Settings.appearance.radius2
  border.color: theme.button.border
  border.width: Settings.appearance.enableBorder ? 3 : 0
  property var theme: ThemeService.theme
  property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"
  RowLayout {
    anchors.centerIn: parent
    spacing: 15

    ButtonIconImage{
      path: "launcher/dashboard.png"
      size: "large"
      onClicked: VisibleService.togglePanel("launcher");
    }
  }
}
