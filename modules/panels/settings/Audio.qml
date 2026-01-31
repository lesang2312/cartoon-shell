// components/Settings/AudioSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services

Item {
    property var theme : ThemeService.theme
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        
        ColumnLayout {
            width: parent.width
            spacing: 20
            
            // Tiêu đề
             RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                // Button Nâng cao ở góc trái

                
                Item {
                    Layout.fillWidth: true
                }
                
                // Tiêu đề (được đẩy sang bên phải)
                Text {
                    text: "Audio Settings"
                    color: theme.primary.foreground
                    font.pixelSize: 24
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.foreground
            }
        }
    }
}
