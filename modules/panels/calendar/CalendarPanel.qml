import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import qs.commons
import "." as Com

PanelWindow {
  id: wtDetailPanel

  property real animationProgress: 0
  SequentialAnimation on animationProgress {
    id: staggerAnimation
    running: true
    loops: 1

    PropertyAction { value: 0 }

    NumberAnimation { to: 0.2; duration: 50 }
  }

  implicitWidth: ScalerService.s(500)
  implicitHeight: ScalerService.s(500)

  anchors {
    top: Settings.bar.position === "top"
    bottom: Settings.bar.position === "bottom"
    left: Settings.bar.position === "top" || Settings.bar.position === "bottom" || Settings.bar.position === "left"
    right: Settings.bar.position === "right"
  }

  margins {
    top: Settings.bar.position === "top" ? ScalerService.s(10) : 0
    bottom: Settings.bar.position === "bottom" ? ScalerService.s(10) : 0
    left: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? ScalerService.s(800) : ScalerService.s(10)
    right: Settings.bar.position === "right" ? ScalerService.s(10) : 0
  }
  exclusiveZone: 0
  color: "transparent"

  Rectangle {
    anchors.fill: parent
    color: theme.primary.background
    border.color: theme.button.border
    radius: ScalerService.s(Settings.appearance.radius1)
    border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: ScalerService.s(20)
      spacing: ScalerService.s(16)

      Com.CalendarHeader {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(70)
      }

      Com.CalendarDislay {
        Layout.alignment: Qt.AlignHCenter
      }
    }
  }
}
