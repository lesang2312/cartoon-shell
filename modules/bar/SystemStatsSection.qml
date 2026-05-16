import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.services
import qs.commons
import qs.components

Rectangle {
  id: root
  color: theme.primary.background
  border.color: theme.button.border
  border.width: 3
  radius: 10
  clip: true

  property string memoryUsage: "0%"
  property var theme: ThemeService.theme
  property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"

  CpuService {
    id: cpuService
    enableCpuHistory: false
  }

  RamService {
    id: ramService
    useSimpleCalculation: true
  }

  // UI Layout
  Loader {
    anchors.fill: parent
    anchors.margins: isVertical ? 6 : 4
    sourceComponent: isVertical ? verticalLayout : horizontalLayout
  }

  Component {
    id: horizontalLayout

    RowLayout {
      anchors.fill: parent
      spacing: 4

      // CPU Container
      Rectangle {
        id: cpuContainer
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"
        radius: 6

        RowLayout {
          id: cpuContent
          anchors.centerIn: parent
          spacing: 2

          ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 0
            CustomText {
              name: cpuService.cpuPercent + "%"
              isBold: true
              size: "small"
              Layout.alignment: Qt.AlignHCenter

            }
            CustomText {
              name: "Cpu"
              textColor: theme.primary.dim_foreground
              size: "2xs"
              Layout.alignment: Qt.AlignHCenter

            }
          }

          IconImage {
            visible: Settings.bar.cpu.isImage
            path: "cpu/cpu.png"
            Layout.alignment: Qt.AlignVCenter
          }
          IconText {
            visible: Settings.bar.cpu.isIcon
            name: "memory"
            textColor: theme.button.text
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            VisibleService.togglePanel("cpu");
          }
          onEntered: cpuContainer.opacity = 0.8
          onExited: cpuContainer.opacity = 1.0
        }

        Behavior on opacity {
          NumberAnimation {
            duration: 100
          }
        }
      }

      // Memory Container
      Rectangle {
        id: memoryContainer
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"
        radius: 6

        RowLayout {
          id: memoryContent
          anchors.centerIn: parent
          spacing: 2

          ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 0
            CustomText {
              name: ramService.memPercent + "%"
              isBold: true
              size: "small"
              Layout.alignment: Qt.AlignHCenter

            }
            CustomText {
              name: "Ram"
              textColor: theme.primary.dim_foreground
              size: "2xs"
              Layout.alignment: Qt.AlignHCenter

            }
          }

          IconImage {
            visible: Settings.bar.ram.isImage
            path: "panel/memory.png"
            Layout.alignment: Qt.AlignVCenter
          }
          IconText {
            visible: Settings.bar.ram.isIcon
            name: "memory_alt"
            textColor: theme.button.text
          }

        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            VisibleService.togglePanel("ram");
          }
          onEntered: memoryContainer.opacity = 0.8
          onExited: memoryContainer.opacity = 1.0
        }

        Behavior on opacity {
          NumberAnimation {
            duration: 100
          }
        }
      }
    }
  }

  Component {
    id: verticalLayout

    ColumnLayout {
      anchors.fill: parent
      spacing: 8

      // CPU Container (vertical)
      Rectangle {
        id: cpuContainerVertical
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"
        radius: 6

        // Xoay container để hiển thị dọc
        Item {
          anchors.centerIn: parent
          width: parent.height  // Đảo width và height
          height: parent.width
          transformOrigin: Item.Center

          ColumnLayout {
            anchors.centerIn: parent
            spacing: 4

            ColumnLayout {
              Layout.alignment: Qt.AlignVCenter
              spacing: 0
              Text {
                id: cpuLabelVertical
                text: "CPU"
                color: theme.primary.dim_foreground
                font {
                  family: "ComicShannsMono Nerd Font"
                  pixelSize: 13
                }
                Layout.alignment: Qt.AlignHCenter
              }
              Text {
                id: cpuTextVertical
                text: cpuService.cpuPercent + "%"
                color: theme.primary.foreground
                font {
                  family: "ComicShannsMono Nerd Font"
                  pixelSize: 12
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
        radius: 6

        // Xoay container để hiển thị dọc
        Item {
          anchors.centerIn: parent
          width: parent.height  // Đảo width và height
          height: parent.width
          transformOrigin: Item.Center

          ColumnLayout {
            anchors.centerIn: parent
            spacing: 4

            ColumnLayout {
              Layout.alignment: Qt.AlignVCenter
              spacing: 0

              Text {
                id: memoryLabelVertical
                text: "RAM"
                color: theme.primary.dim_foreground
                font {
                  family: "ComicShannsMono Nerd Font"
                  pixelSize: 14
                }
                Layout.alignment: Qt.AlignHCenter
              }
              Text {
                id: memoryTextVertical
                text: ramService.memPercent + "%"
                color: theme.primary.foreground
                font {
                  family: "ComicShannsMono Nerd Font"
                  pixelSize: 12
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
