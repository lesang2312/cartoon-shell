//SystemStatsSection
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.services
import qs.commons
import qs.components
import qs.services.cpu
import "./widget/" as Com

Rectangle {
  id: root
  color: theme.primary.background
  border.color: theme.button.border
  border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
  radius: ScalerService.s(Settings.appearance.radius2)
  clip: true

  property string memoryUsage: "0%"
  property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"

  RamService {
    id: ramService
    useSimpleCalculation: true
  }

  // UI Layout
  Loader {
    anchors.fill: parent
    anchors.margins: isVertical ? ScalerService.s(6) : ScalerService.s(4)
    sourceComponent: isVertical ? verticalLayout : horizontalLayout
  }

  Component {
    id: horizontalLayout

    RowLayout {
      anchors.fill: parent
      spacing: ScalerService.s(4)

      // CPU Container
      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true
        panelName: "cpu"

        Com.CpuStat {
          anchors.centerIn: parent
        }
      }
      Com.StatContainer {
        Layout.fillWidth: true
        Layout.fillHeight: true
        panelName: "ram"

        Com.RamStat {
          anchors.centerIn: parent
        }
      }
    }
  }

  Component {
    id: verticalLayout

    ColumnLayout {
      anchors.fill: parent
      spacing: ScalerService.s(8)

      // CPU Container (vertical)
      Rectangle {
        id: cpuContainerVertical
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"
        radius: ScalerService.s(6)

        // Xoay container để hiển thị dọc
        Item {
          anchors.centerIn: parent
          width: parent.height  // Đảo width và height
          height: parent.width
          transformOrigin: Item.Center

          ColumnLayout {
            anchors.centerIn: parent
            spacing: ScalerService.s(4)

            ColumnLayout {
              Layout.alignment: Qt.AlignVCenter
              spacing: 0
              Text {
                id: cpuLabelVertical
                text: "CPU"
                color: theme.primary.dim_foreground
                font {
                  family: "ComicShannsMono Nerd Font"
                  pixelSize: ScalerService.s(13)
                }
                Layout.alignment: Qt.AlignHCenter
              }
              Text {
                id: cpuTextVertical
                text: CpuSimpleService.cpuPercent + "%"
                color: theme.primary.foreground
                font {
                  family: "ComicShannsMono Nerd Font"
                  pixelSize: ScalerService.s(12)
                  bold: true
                }
                Layout.alignment: Qt.AlignHCenter
              }
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            VisibleService.togglePanel("cpu");
          }
          onEntered: cpuContainerVertical.opacity = 0.8
          onExited: cpuContainerVertical.opacity = 1.0
        }

        Behavior on opacity {
          NumberAnimation {
            duration: 100
          }
        }
      }

      // Memory Container (vertical)
      Rectangle {
        id: memoryContainerVertical
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"
        radius: ScalerService.s(6)

        // Xoay container để hiển thị dọc
        Item {
          anchors.centerIn: parent
          width: parent.height  // Đảo width và height
          height: parent.width
          transformOrigin: Item.Center

          ColumnLayout {
            anchors.centerIn: parent
            spacing: ScalerService.s(4)

            ColumnLayout {
              Layout.alignment: Qt.AlignVCenter
              spacing: 0

              Text {
                id: memoryLabelVertical
                text: "RAM"
                color: theme.primary.dim_foreground
                font {
                  family: "ComicShannsMono Nerd Font"
                  pixelSize: ScalerService.s(14)
                }
                Layout.alignment: Qt.AlignHCenter
              }
              Text {
                id: memoryTextVertical
                text: ramService.memPercent + "%"
                color: theme.primary.foreground
                font {
                  family: "ComicShannsMono Nerd Font"
                  pixelSize: ScalerService.s(12)
                  bold: true
                }
                Layout.alignment: Qt.AlignHCenter
              }
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            VisibleService.togglePanel("ram");
          }
          onEntered: memoryContainerVertical.opacity = 0.8
          onExited: memoryContainerVertical.opacity = 1.0
        }

        Behavior on opacity {
          NumberAnimation {
            duration: 100
          }
        }
      }
    }
  }
}
