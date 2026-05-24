import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import qs.services
import qs.components
import qs.commons

Rectangle {
  id: root

  property var theme : ThemeService.theme
  property real animationProgress: 0

  Layout.fillWidth: true
  Layout.preferredHeight: 120
  color: theme.primary.background
  radius: Settings.appearance.radius1
  border.width: Settings.appearance.enableBorder ? 3 : 0
  border.color: theme.button.border
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  RowLayout {
    anchors.fill: parent
    anchors.margins: 20
    spacing: 20

    IconImage {
      path: "dashboard/clock.png"
      size: "2xl"
      opacity: root.animationProgress > 0.6 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }

    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2

      CustomText {
        name: UptimeService.uptimeHours + " hours"
        isBold: true
        textColor: theme.button.text
        size: "xl"
        opacity: root.animationProgress > 0.65 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }
      CustomText {
        name: UptimeService.uptimeMinutes + " minutes"
        textColor: theme.primary.foreground
        size: "normal"
        opacity: root.animationProgress > 0.7 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }

      }

    }
  }
}
