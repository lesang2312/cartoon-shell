import QtQuick
import qs.services

Item {
    id: header
    signal closeClicked

    property var theme: ThemeService.theme
    property var lang: LanguageService.translations

    Row {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: lang.CpuPane.title
            color: theme.primary.foreground
            font.pixelSize: 40
            font.bold: true
            font.family: "ComicShannsMono Nerd Font"
        }
    }
}
