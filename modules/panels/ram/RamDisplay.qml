import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Io
import Quickshell
import qs.services
import qs.components
import "." as Com
import qs.commons

Item {
  id: ramDisplay
  property var lang: LanguageService.translations
  property var theme: ThemeService.theme
  property real animationProgress: 0

  RamService {
    id: ramService
    useSimpleCalculation: false
  }

  property bool dataLoaded: true

  Rectangle {
    anchors.fill: parent
    color: theme.primary.background
    radius: Settings.appearance.radius2
    border.width: Settings.appearance.enableBorder ? 2 : 0
    border.color: theme.button.border
    opacity: root.animationProgress > 0.2 ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }

    Rectangle {
      anchors.fill: parent
      color: "transparent"
      opacity: 0.1
      radius: 12

      Canvas {
        anchors.fill: parent
        onPaint: {
          var ctx = getContext("2d");
          ctx.strokeStyle = theme.primary.foreground;
          ctx.lineWidth = 0.5;

          for (var x = 0; x < width; x += 15) {
            ctx.beginPath();
            ctx.moveTo(x, 0);
            ctx.lineTo(x, height);
            ctx.stroke();
          }
          for (var y = 0; y < height; y += 15) {
            ctx.beginPath();
            ctx.moveTo(0, y);
            ctx.lineTo(width, y);
            ctx.stroke();
          }
        }
      }
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 16
    spacing: 16

    RowLayout {
      Layout.fillWidth: true

      CustomText{
        name: lang?.ram?.memory_monitor || "Memory Monitor"
        size: "large"
        isBold: true
        opacity: root.animationProgress > 0.2 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }

      Item {
        Layout.fillWidth: true
      }

      Rectangle {
        width: root.animationProgress > 0.25 ? 8 : 0
        height: root.animationProgress > 0.25 ? 8 : 0
        radius: 4
        color: ramService.memPercent > 80 ? theme.normal.red : ramService.memPercent > 60 ? theme.normal.yellow : theme.normal.green
        opacity: root.animationProgress > 0.2 ? 1 : 0
        Behavior on color {
          ColorAnimation { duration: 150 }
        }
        Behavior on height {
          NumberAnimation {
            duration: 200
          }
        }
        Behavior on width {
          NumberAnimation {
            duration: 200
          }
        }
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 6

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 4

        RowLayout {
          Layout.fillWidth: true

          CustomText {
            name: "RAM"
            isBold: true
            opacity: root.animationProgress > 0.3 ? 1 : 0
            Behavior on opacity {
              NumberAnimation {
                duration: 200
              }
            }
          }

          Item {
            Layout.fillWidth: true
          }

          CustomText {
            name: ramService.memPercent + "%"
            isBold: true
            textColor: getUsageColor(ramService.memPercent)
            opacity: root.animationProgress > 0.35 ? 1 : 0
            Behavior on opacity {
              NumberAnimation {
                duration: 200
              }
            }
          }
        }

        Rectangle {
          Layout.fillWidth: true
          height: 20
          radius: 10
          color: theme.primary.dim_background

          Rectangle {
            width: parent.width * (ramService.memPercent / 100)
            height: parent.height
            radius: 10
            color: getUsageColor(ramService.memPercent)
            Behavior on width {
              NumberAnimation {
                duration: 800
                easing.type: Easing.OutCubic
              }
            }
          }

        }
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: 12
        Com.RamItemMemoryMonitor{
          name: lang?.ram?.used || "Used"
          value: ramService.memUsed + " MB"
          opacity: root.animationProgress > 0.4 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
        Com.RamItemMemoryMonitor{
          name: lang?.ram?.free || "Free"
          value: ramService.memFree + " MB"
          opacity: root.animationProgress > 0.45 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
        Com.RamItemMemoryMonitor{
          name:  "Total"
          value: ramService.memTotal + " MB"
          opacity: root.animationProgress > 0.5 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }
    }

    Rectangle {
      Layout.fillWidth: true
      height: 1
      color: "transparent"

      Rectangle {
        anchors.centerIn: parent
        width: root.animationProgress > 0.9 ? parent.width * 0.8 : 0
        height: 1
        color: theme.primary.foreground
        Behavior on width {
          NumberAnimation {
            duration: 400
          }
        }
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 6

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 4

        RowLayout {
          Layout.fillWidth: true
          CustomText {
            name: "SWAP"
            isBold: true
            opacity: root.animationProgress > 0.6 ? 1 : 0
            Behavior on opacity {
              NumberAnimation {
                duration: 200
              }
            }
          }

          Item {
            Layout.fillWidth: true
          }

          CustomText {
            name: ramService.swapPercent + "%"
            isBold: true
            textColor: getUsageColor(ramService.swapPercent)
            opacity: root.animationProgress > 0.65 ? 1 : 0
            Behavior on opacity {
              NumberAnimation {
                duration: 200
              }
            }
          }

        }

        Rectangle {
          Layout.fillWidth: true
          height: 14
          radius: 7
          color: theme.primary.dim_background
          opacity: ramService.swapTotal > 0 ? 1 : 0.3

          Rectangle {
            width: parent.width * (ramService.swapPercent / 100)
            height: parent.height
            radius: 7
            color: getUsageColor(ramService.swapPercent)

            Behavior on width {
              NumberAnimation {
                duration: 800
                easing.type: Easing.OutCubic
              }
            }
          }
        }
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: 12
        Com.RamItemMemoryMonitor{
          name: lang?.ram?.used || "Used"
          value: ramService.swapFree + " MB"
          opacity: root.animationProgress > 0.7 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
        Com.RamItemMemoryMonitor{
          name: lang?.ram?.free || "Free"
          value: ramService.swapFree + " MB"
          opacity: root.animationProgress > 0.75 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
        Com.RamItemMemoryMonitor{
          name:  "Total"
          value: ramService.swapTotal + " MB"
          opacity: root.animationProgress > 0.8 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
      }
    }
  }

  Rectangle {
    anchors.fill: parent
    color: theme.primary.background
    radius: 12
    opacity: dataLoaded ? 0 : 1
    visible: opacity > 0

    Behavior on opacity {
      NumberAnimation {
        duration: 300
      }
    }

    Column {
      anchors.centerIn: parent
      spacing: 12

      Text {
        text: lang?.ram?.loading_memory || "Loading memory data..."
        color: theme.primary.foreground
        font.pixelSize: 10
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }
  }

  function getUsageColor(percent) {
    if (percent > 90)
    return theme.normal.red;
    if (percent > 70)
    return theme.normal.yellow;
    if (percent > 50)
    return theme.normal.green;
    return theme.normal.cyan;
  }
}
