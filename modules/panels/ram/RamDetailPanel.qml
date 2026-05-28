import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "." as Components
import qs.services
import qs.commons

PanelWindow {
  id: root

  implicitWidth: ScalerService.s(930)
  implicitHeight: ScalerService.s(960)

  anchors {
    top: Settings.bar.position === "top"
    bottom: Settings.bar.position === "bottom"
    left: Settings.bar.position === "top" || Settings.bar.position === "bottom" || Settings.bar.position === "left"
    right: Settings.bar.position === "right"
  }

  margins {
    top: Settings.bar.position === "top" ? ScalerService.s(10) : 0
    bottom: Settings.bar.position === "bottom" ? ScalerService.s(10) : 0
    left: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? ScalerService.s(400) : ScalerService.s(10)
    right: Settings.bar.position === "right" ? ScalerService.s(10) : 0
  }

  exclusiveZone: 0
  color: "transparent"

  property real animationProgress: 0
  SequentialAnimation on animationProgress {
    running: true

    NumberAnimation {
      from: 0
      to: 2
      duration: 1000
      easing.type: Easing.Linear
    }
  }

  Rectangle {
    anchors.centerIn: parent
    implicitWidth: root.animationProgress > 0 ? parent.width : parent.width * 0.2
    implicitHeight: root.animationProgress > 0 ? parent.height : parent.height * 0.2
    Behavior on implicitHeight {
      NumberAnimation {
        duration: 500
        easing.type: Easing.OutCubic
      }
    }
    Behavior on implicitWidth {
      NumberAnimation {
        duration: 500
        easing.type: Easing.OutCubic
      }
    }
    color: theme.primary.background
    border.color: theme.button.border
    radius: ScalerService.s(Settings.appearance.radius1)
    border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: ScalerService.s(16)
      spacing: ScalerService.s(30)

      Components.RamDetailHeader {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(40)
        animationProgress : root.animationProgress
      }

      Components.RamDisplay {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(330)
        animationProgress : root.animationProgress
      }

      Components.RamTaskManager {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(500)
        animationProgress : root.animationProgress
      }
    }
  }
}
