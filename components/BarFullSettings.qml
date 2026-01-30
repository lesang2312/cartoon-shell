import QtQuick
import QtQuick.Layouts
import qs.services

Item {
    property var theme: ThemeService.theme
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        
        Item {
            Layout.fillWidth: true
        }
        
        // Nút "-"
        Rectangle {
            id: minimizeButton
            width: 25
            height: 25
            radius: 5
            color: theme.primary.dim_background
            border {
                color: theme.button.border
                width: 2
            }
            
            property bool hovered: false
            
            Text {
                id: minimizeText
                text: "-"
                font.pixelSize: 16
                anchors.centerIn: parent
                color: theme.primary.foreground
                
                // Thêm scale khi hover
                property real normalScale: 1.0
                property real hoverScale: 1.2
                scale: parent.hovered ? hoverScale : normalScale
                
                // Hiệu ứng mượt cho scale
                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: minimizeButton.hovered = true
                onExited: minimizeButton.hovered = false
                onClicked: {
                    panelManager.togglePanel("fullsetting")
                }
            }
        }
        
        // Nút "x"
        Rectangle {
            id: closeButton
            width: 25
            height: 25
            radius: 5
            color: theme.primary.dim_background
            border {
                color: theme.button.border
                width: 2
            }
            
            property bool hovered: false
            
            Text {
                id: closeText
                text: "x"
                font.pixelSize: 16
                anchors.centerIn: parent
                color: theme.primary.foreground
                
                // Thêm scale khi hover
                property real normalScale: 1.0
                property real hoverScale: 1.2
                scale: parent.hovered ? hoverScale : normalScale
                
                // Hiệu ứng mượt cho scale
                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: closeButton.hovered = true
                onExited: closeButton.hovered = false
                onClicked: {
                    panelManager.togglePanel("launcher")
                }
            }
        }
    }
}
