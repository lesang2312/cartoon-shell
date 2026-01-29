import QtQuick
import qs.services

Item {
    id: header

    property var theme : ThemeService.theme

    property var lang: currentLanguage

    signal closeClicked()

    Row {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: lang?.calendar?.title || "Lịch"
            color: theme.primary.foreground
            font.pixelSize: 40
            font.bold: true
            font.family: "ComicShannsMono Nerd Font"
        }
    }
}
