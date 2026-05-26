import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import qs.services.cpu
import qs.commons
import qs.components

Item {
  id: root
  CpuAppService {
    id: cpuAppService
  }
  property real animationProgress: 2
  property var processList: cpuAppService.listAppCpu
  function getPercentageColor(percent) {
    if (percent > 90)
    return theme.normal.red;
    if (percent > 70)
    return theme.normal.yellow;
    if (percent > 50)
    return theme.normal.green;
    return theme.normal.cyan;
  }
  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 16
    spacing: 12

    Rectangle {
      Layout.fillWidth: true
      color: theme.primary.background
      Layout.preferredHeight: 50
      radius: 8

      CustomText {
        anchors.centerIn: parent
        name: lang.ram.title
        isBold: true
        opacity: root.animationProgress > 0.85 ? 1 : 0
      }
    }

    Rectangle {
      Layout.fillWidth: true
      height: 32
      color: theme.button.background
      opacity: root.animationProgress > 0.5 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
      radius: 6

      RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        CustomText {
          name: "PID"
          size: "small"
          isBold: true
          textColor: theme.button.text
          Layout.preferredWidth: 70
          opacity: root.animationProgress > 1 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
        CustomText {
          name: "Name"
          size: "small"
          isBold: true
          textColor: theme.button.text
          Layout.fillWidth: true
          opacity: root.animationProgress > 1.05 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
        CustomText {
          name: "CPU %"
          size: "small"
          isBold: true
          textColor: theme.button.text
          Layout.preferredWidth: 80
          horizontalAlignment: Text.AlignRight
          opacity: root.animationProgress > 1.1 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
        CustomText {
          name: "Memory"
          size: "small"
          isBold: true
          textColor: theme.button.text
          Layout.preferredWidth: 100
          horizontalAlignment: Text.AlignRight
          opacity: root.animationProgress > 1.15 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }
    }
    Flickable {
      id: processFlick
      Layout.fillWidth: true
      Layout.fillHeight: true

      clip: true
      contentWidth: width
      contentHeight: processColumn.height

      boundsBehavior: Flickable.StopAtBounds

      Column {
        id: processColumn
        width: processFlick.width
        spacing: 2

        Repeater {
          model: root.processList

          delegate: Rectangle {
            width: processFlick.width
            height: 50

            color: index % 2 === 0
            ? theme.primary.background
            : theme.primary.dim_background

            radius: 6
            border.color: Qt.lighter(color, 1.1)
            border.width: 1

            RowLayout {
              anchors.fill: parent
              anchors.margins: 10
              spacing: 10

              CustomText {
                name: modelData.pid
                size: "small"
                textColor: theme.button.text
                Layout.preferredWidth: 70
                opacity: root.animationProgress > 1.5 ? 1 : 0

                SequentialAnimation on opacity {
                  running: root.animationProgress > 1.2

                  PauseAnimation {
                    duration: index * 15
                  }

                  NumberAnimation {
                    to: 1
                    duration: 200
                    easing.type: Easing.OutCubic
                  }
                }
              }

              CustomText {
                name: modelData.name
                size: "small"
                textColor: theme.primary.foreground
                Layout.fillWidth: true
                opacity: root.animationProgress > 1.5 ? 1 : 0

                SequentialAnimation on opacity {
                  running: root.animationProgress > 1.25

                  PauseAnimation {
                    duration: index * 15
                  }

                  NumberAnimation {
                    to: 1
                    duration: 200
                    easing.type: Easing.OutCubic
                  }
                }
              }

              CustomText {
                name: modelData.cpu + "%"
                size: "small"
                textColor: getPercentageColor(modelData.cpu)
                Layout.preferredWidth: 80
                horizontalAlignment: Text.AlignRight
                opacity: root.animationProgress > 1.5 ? 1 : 0

                SequentialAnimation on opacity {
                  running: root.animationProgress > 1.3

                  PauseAnimation {
                    duration: index * 15
                  }

                  NumberAnimation {
                    to: 1
                    duration: 200
                    easing.type: Easing.OutCubic
                  }
                }
              }

              CustomText {
                name: modelData.mem.toFixed(1) + " MB"
                size: "small"
                textColor: theme.primary.foreground
                Layout.preferredWidth: 100
                horizontalAlignment: Text.AlignRight
                opacity: root.animationProgress > 1.5 ? 1 : 0

                SequentialAnimation on opacity {
                  running: root.animationProgress > 1.35

                  PauseAnimation {
                    duration: index * 15
                  }

                  NumberAnimation {
                    to: 1
                    duration: 200
                    easing.type: Easing.OutCubic
                  }
                }
              }
            }

            Rectangle {
              anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 6
              }

              height: 3
              radius: 1.5
              color: theme.primary.dim_background

              Rectangle {
                width: root.animationProgress > 1.5
                ? parent.width * Math.min(modelData.percent / 30, 1)
                : 0

                height: parent.height
                radius: 1.5
                color: getPercentageColor(modelData.percent)

                Behavior on width {
                  NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutCubic
                  }
                }
              }
            }
          }
        }
      }

      Rectangle {
        visible: root.processList.length === 0
        anchors.fill: parent
        color: "transparent"

        Column {
          anchors.centerIn: parent
          spacing: 12

          Text {
            text: "⏳"
            font.pixelSize: 30
            color: theme.primary.dim_foreground
          }

          Text {
            text: lang.ram.loading.message
            font.family: "ComicShannsMono Nerd Font"
            color: theme.primary.dim_foreground
            font.pixelSize: 14
          }
        }
      }

    }

  }

}
