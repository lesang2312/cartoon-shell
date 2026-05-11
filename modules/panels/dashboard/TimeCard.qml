import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell
import qs.services
import qs.components

Rectangle {
  id: root

  property var theme : ThemeService.theme

  Layout.fillWidth: true
  Layout.preferredHeight: 120
  radius: 28
  color: theme.primary.background
  border.width: 3
  border.color: theme.button.border

  RowLayout {
    anchors.fill: parent
    anchors.margins: 20
    spacing: 15

    // Phần hiển thị thời gian (giờ và phút)
    ColumnLayout {
      spacing: 2
      Text {
        text: DateTimeService.currentHour
        color: theme.primary.foreground
        font {
          pixelSize: 30
          bold: true
          family: "ComicShannsMono Nerd Font"
        }
      }

      Text {
        text: DateTimeService.currentMinus
        color: theme.primary.foreground
        font {
          pixelSize: 30
          bold: true
          family: "ComicShannsMono Nerd Font"
        }
      }
    }

    Rectangle {
      Layout.preferredWidth: 4
      Layout.preferredHeight: 90
      color: theme.primary.foreground
      radius: 2
    }

    // Phần hiển thị ngày tháng
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2
      CustomText {
        name: DateTimeService.currentDay
        isBold: true
        size: "xl"
      }
      CustomText {
        name: `${DateTimeService.currentOfDays} ${DateTimeService.currentMonth} ${DateTimeService.currentYear}`
        size: "normal"
        isBold: true

      }
    }
  }
}
