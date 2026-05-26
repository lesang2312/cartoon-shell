import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell
import qs.services
import qs.components
import qs.commons

Rectangle {
  id: root

  property real animationProgress: 0

  Layout.fillWidth: true
  Layout.preferredHeight: 120
  color: theme.primary.background
  radius: Settings.appearance.radius1
  border.width: Settings.appearance.enableBorder ? 3 : 0
  border.color: theme.button.border
  clip: true
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  RowLayout {
    anchors.fill: parent
    anchors.margins: 20
    spacing: 15

    // Phần hiển thị thời gian (giờ và phút)
    ColumnLayout {
      spacing: 2
      CustomText {
        name: DateTimeService.currentHour
        size: "large"
        isBold: true
        opacity: root.animationProgress > 0.4 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }

      CustomText {
        name: DateTimeService.currentMinus
        size: "large"
        isBold: true
        opacity: root.animationProgress > 0.43 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }
    }

    Rectangle {
      Layout.preferredWidth: 4
      Layout.preferredHeight: root.animationProgress > 0.47 ? 70 : 0
      color: theme.primary.foreground
      radius: 2
      Behavior on Layout.preferredHeight {
        NumberAnimation {
          duration: 500
        }
      }
    }

    // Phần hiển thị ngày tháng
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2
      CustomText {
        name: DateTimeService.currentDay
        isBold: true
        size: "xl"
        opacity: root.animationProgress > 0.5 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }
      CustomText {
        name: `${DateTimeService.currentOfDays} ${DateTimeService.currentMonth} ${DateTimeService.currentYear}`
        size: "normal"
        isBold: true
        opacity: root.animationProgress > 0.55 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }

      }
    }
  }
}
