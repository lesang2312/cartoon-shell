import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components
import qs.services
import qs.commons

PanelWindow {
  id: detailPanel

  implicitWidth: ScalerService.s(1000)
  implicitHeight: ScalerService.s(850)

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

  signal closeRequested

  Rectangle {
    anchors.fill: parent
    color: theme.primary.background
    border.color: theme.button.border
    radius: ScalerService.s(Settings.appearance.radius1)
    border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: ScalerService.s(16)
      spacing: ScalerService.s(16)

      // Header với nút đóng
      Components.CpuDetailHeader {
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height * 0.1
      }
      // Thông tin CPU
      Components.CpuInfoSection {
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height * 0.2
      }

      // chia đôi ra
      Item {
        Layout.fillHeight: true
        Layout.fillWidth: true
        RowLayout {
          anchors.fill: parent

          ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // BIỂU ĐỒ CPU USAGE
            Components.CpuUsageChart {
              Layout.fillWidth: true
              Layout.fillHeight: true
            }
          }

          // List app CPU
          Components.CpuTaskManager {
            Layout.preferredWidth: parent.width * 0.5
            Layout.fillHeight: true

          }
        }

      }

    }
  }
}
