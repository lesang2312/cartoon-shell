import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.commons
import "." as Com

PanelWindow {
  id: root

  property string selectedFlag: Settings.appearance.countryFlag
  property real animationProgress: 0

  SequentialAnimation on animationProgress {
    running: true

    NumberAnimation {
      from: 0
      to: 1
      duration: 500
      easing.type: Easing.Linear
    }
  }

  implicitWidth: root.animationProgress > 0.1 ? 600 : 100
  implicitHeight: root.animationProgress > 0.1 ? 420 : 100

  Behavior on implicitHeight {
    NumberAnimation { duration: 60; easing.type: Easing.OutCubic }
  }

  Behavior on implicitWidth {
    NumberAnimation { duration: 60; easing.type: Easing.OutCubic }
  }

  property var flagList: [
  { name: "britain", displayName: "Britain" },
  { name: "bulgaria", displayName: "Bulgaria" },
  { name: "china", displayName: "China" },
  { name: "czech", displayName: "Czech" },
  { name: "denmark", displayName: "Denmark" },
  { name: "finland", displayName: "Finland" },
  { name: "france", displayName: "France" },
  { name: "german", displayName: "Germany" },
  { name: "greece", displayName: "Greece" },
  { name: "hungary", displayName: "Hungary" },
  { name: "india", displayName: "India" },
  { name: "indonesia", displayName: "Indonesia" },
  { name: "israel", displayName: "Israel" },
  { name: "italy", displayName: "Italy" },
  { name: "japan", displayName: "Japan" },
  { name: "korea", displayName: "Korea" },
  { name: "netherlands", displayName: "Netherlands" },
  { name: "norway", displayName: "Norway" },
  { name: "poland", displayName: "Poland" },
  { name: "portugal", displayName: "Portugal" },
  { name: "romania", displayName: "Romania" },
  { name: "russia", displayName: "Russia" },
  { name: "saudi_arabia", displayName: "Saudi Arabia" },
  { name: "slovakia", displayName: "Slovakia" },
  { name: "spain", displayName: "Spain" },
  { name: "sweden", displayName: "Sweden" },
  { name: "thailand", displayName: "Thailand" },
  { name: "turkey", displayName: "Turkey" },
  { name: "ukraine", displayName: "Ukraine" },
  { name: "vietnam", displayName: "Vietnam" }
  ]

  anchors {
    top: Settings.bar.position === "top"
    bottom: Settings.bar.position === "bottom"
    left: Settings.bar.position === "top" || Settings.bar.position === "bottom" || Settings.bar.position === "left"
    right: Settings.bar.position === "right"
  }

  margins {
    top: Settings.bar.position === "top" ? 10 : 0
    bottom: Settings.bar.position === "bottom" ? 10 : 0
    left: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? 720 : 10
    right: Settings.bar.position === "right" ? 10 : 0
  }

  exclusiveZone: 0
  color: "transparent"

  Rectangle {
    anchors.fill: parent
    color: theme.primary.background
    border.color: theme.button.border
    radius: Settings.appearance.radius1
    border.width: Settings.appearance.enableBorder ? 3 : 0

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 20
      spacing: 15

      Com.FlagHeader {
        animationProgress: root.animationProgress
      }

      Com.FlagGrid {
        Layout.fillWidth: true
        Layout.fillHeight: true
        flagList: root.flagList
        selectedFlag: root.selectedFlag
        animationProgress: root.animationProgress
      }

      Com.FlagFooter {
        selectedFlag: root.selectedFlag
        animationProgress: root.animationProgress
      }
    }
  }
}
