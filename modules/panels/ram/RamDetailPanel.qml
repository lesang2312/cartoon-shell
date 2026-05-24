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

  implicitWidth: root.animationProgress > 0.1 ?  930 : 100
  implicitHeight: root.animationProgress > 0.1 ?  960 : 100

  Behavior on implicitHeight {
    NumberAnimation {
      duration: 100
      easing.type: Easing.OutCubic
    }
  }
  Behavior on implicitWidth {
    NumberAnimation {
      duration: 100
      easing.type: Easing.OutCubic
    }
  }

  anchors {
    top: Settings.bar.position === "top"
    bottom: Settings.bar.position === "bottom"
    left: Settings.bar.position === "top" || Settings.bar.position === "bottom" || Settings.bar.position === "left"
    right: Settings.bar.position === "right"
  }

  margins {
    top: Settings.bar.position === "top" ? 10 : 0
    bottom: Settings.bar.position === "bottom" ? 10 : 0
    left: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? 400 : 10
    right: Settings.bar.position === "right" ? 10 : 0
  }

  exclusiveZone: 0
  color: "transparent"

  property var theme: ThemeService.theme
  property var lang: LanguageService.translations
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
    anchors.fill: parent
    color: theme.primary.background
    border.color: theme.button.border
    radius: Settings.appearance.radius1
    border.width: Settings.appearance.enableBorder ? 3 : 0

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 30

      Components.RamDetailHeader {
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        animationProgress : root.animationProgress
      }

      Components.RamDisplay {
        Layout.fillWidth: true
        Layout.preferredHeight: 330
        animationProgress : root.animationProgress
      }

      Components.RamTaskManager {
        Layout.fillWidth: true
        Layout.preferredHeight: 500
        animationProgress : root.animationProgress
      }
    }
  }
}
