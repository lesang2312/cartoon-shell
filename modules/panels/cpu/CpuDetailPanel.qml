import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components
import qs.services
import qs.commons

PanelWindow {
  id: detailPanel

  implicitWidth: 1030
  implicitHeight: 850

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

  signal closeRequested

  property var theme: ThemeService.theme

  // Process để lấy CPU usage tổng
  CpuService {
    id: cpuService
    enableCpuHistory: true
    enableProcessList: true
  }

  Rectangle {
    anchors.fill: parent
    color: theme.primary.background
    radius: 8
    border.color: theme.button.border
    border.width: 3

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 16

      // Header với nút đóng
      Components.CpuDetailHeader {
        Layout.fillWidth: true
        Layout.preferredHeight: 70
      }

      // Thông tin CPU
      Components.CpuInfoSection {
        Layout.fillWidth: true
        Layout.preferredHeight: 120
      }

      // BIỂU ĐỒ CPU USAGE
      Components.CpuUsageChart {
        Layout.fillWidth: true
        Layout.fillHeight: true
        cpuHistory: cpuService.cpuHistory
      }
    }
  }
}
