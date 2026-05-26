import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
  id: emptyState
  color: "transparent"

  Column {
    anchors.centerIn: parent
    spacing: 16

    Rectangle {
      width: 80
      height: 80
      radius: 16
      color: theme.normal.red
      anchors.horizontalCenter: parent.horizontalCenter
      Text {
        text: "📶"
        font.pixelSize: 40
        anchors.centerIn: parent
      }
    }

    Text {
      text: lang?.wifi?.disabled || "WiFi đang tắt"
      font.pixelSize: 18
      color: theme.primary.foreground
      font.family: "ComicShannsMono Nerd Font"
    }

    Text {
      text: lang?.wifi?.turn_on || "Bật WiFi để xem mạng khả dụng"
      font.pixelSize: 14
      color: theme.primary.dim_foreground
      font.family: "ComicShannsMono Nerd Font"
    }
  }
}
