import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
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
    spacing: 20

    Label {
      text: ""
      color: theme.primary.foreground
      font.pixelSize: 48
      font.family: "ComicShannsMono Nerd Font"
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 5

      CustomText {
        name: UptimeService.uptimeHours + " hours"
        isBold: true
        textColor: theme.button.text
        size: "xl"

      }
      CustomText {
        name: UptimeService.uptimeMinutes + " minutes"
        textColor: theme.primary.foreground
        size: "normal"

      }

    }
  }
}
