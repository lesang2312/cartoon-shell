import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar
import qs.commons
import qs.services

PanelWindow {
  id: panel
  // Kích thước cố định cho mỗi hướng

  implicitWidth: (Settings.bar.position === "left" || Settings.bar.position === "right") ? ScalerService.s(40) : Screen.width
  implicitHeight: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? ScalerService.s(50) : Screen.height

  color: "transparent"

  anchors {
    left: (Settings.bar.position === "left" || Settings.bar.position === "top" || Settings.bar.position === "bottom") ? true : false
    right: (Settings.bar.position === "right" || Settings.bar.position === "top" || Settings.bar.position === "bottom") ? true : false
    top: (Settings.bar.position === "top" || Settings.bar.position === "left" || Settings.bar.position === "right") ? true : false
    bottom: (Settings.bar.position === "bottom" || Settings.bar.position === "left" || Settings.bar.position === "right") ? true : false
  }

  margins {
    top: (Settings.bar.position === "top" || Settings.bar.position === "left" || Settings.bar.position === "right") ? ScalerService.s(10) : 0
    left: (Settings.bar.position === "left" || Settings.bar.position === "top" || Settings.bar.position === "bottom") ? ScalerService.s(10) : 0
    right: (Settings.bar.position === "right" || Settings.bar.position === "top" || Settings.bar.position === "bottom") ? ScalerService.s(10) : 0
    bottom: (Settings.bar.position === "bottom" || Settings.bar.position === "left" || Settings.bar.position === "right") ? ScalerService.s(10) : 0
  }

  // Xác định layout dựa trên vị trí
  property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"

  Loader {
    anchors.fill: parent
    sourceComponent: isVertical ? verticalLayout : horizontalLayout
  }

  // Component cho layout ngang (top/bottom)
  Component {
    id: horizontalLayout

    RowLayout {
      anchors.fill: parent
      LauncherSection {
        Layout.preferredWidth: ScalerService.s(60)
        Layout.fillHeight: true
      }
      Item {
        Layout.fillWidth: true
      }
      WorkspaceSection {
        visible: true
        Layout.preferredWidth: ScalerService.s(380)
        Layout.fillHeight: true
      }
      Item {
        Layout.fillWidth: true
      }
      MediaSection {
        Layout.preferredWidth: ScalerService.s(340)
        Layout.fillHeight: true
      }
      Item {
        Layout.fillWidth: true
      }
      InfoSection {
        Layout.preferredWidth: ScalerService.s(400)
        Layout.fillHeight: true
      }
      Item {
        Layout.fillWidth: true
      }
      SystemStatsSection {
        Layout.preferredWidth: ScalerService.s(200)
        Layout.fillHeight: true
      }
      Item {
        Layout.fillWidth: true
      }
      StatusTraySection {
        Layout.preferredWidth: ScalerService.s(430)
        Layout.fillHeight: true
      }
    }
  }

  // Component cho layout dọc (left/right)
  Component {
    id: verticalLayout

    ColumnLayout {
      anchors.fill: parent
      LauncherSection {
        Layout.preferredHeight: ScalerService.s(40)
        Layout.fillWidth: true
      }
      Item {
        Layout.fillHeight: true
      }
      WorkspaceSection {
        visible: true
        Layout.preferredHeight: ScalerService.s(280)
        Layout.fillWidth: true
      }
      Item {
        Layout.fillHeight: true
      }
      MediaSection {
        Layout.preferredHeight: ScalerService.s(180)
        Layout.fillWidth: true
      }
      Item {
        Layout.fillHeight: true
      }
      InfoSection {
        Layout.preferredHeight: ScalerService.s(180)
        Layout.fillWidth: true
      }
      Item {
        Layout.fillHeight: true
      }
      SystemStatsSection {
        Layout.preferredHeight: ScalerService.s(100)
        Layout.fillWidth: true
      }
      Item {
        Layout.fillHeight: true
      }
      StatusTraySection {
        Layout.preferredHeight: ScalerService.s(230)
        Layout.fillWidth: true
      }
    }
  }
}
