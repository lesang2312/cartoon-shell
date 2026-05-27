import QtQuick
import qs.services

Item {
  id: header
  signal closeClicked

  Row {
    anchors.centerIn: parent
    spacing: ScalerService.s(20)

    Text {
      text: lang.CpuPane.title
      color: theme.primary.foreground
      font.pixelSize: ScalerService.s(40)
      font.bold: true
      font.family: "ComicShannsMono Nerd Font"
    }
  }
}
