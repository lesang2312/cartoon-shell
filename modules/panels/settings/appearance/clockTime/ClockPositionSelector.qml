// components/Settings/ClockPositionSelector.qml
import QtQuick
import QtQuick.Layouts
import qs.services
import "." as Com
import qs.commons

Item {
    id: clockPositionSelector
    property var theme : ThemeService.theme

    property var lang : LanguageService.translations
    
    
    implicitHeight: content.implicitHeight
    
    ColumnLayout {
        id: content
        width: parent.width
        spacing: 0
        
        // Label row
        RowLayout {
            id: labelContainer
            Layout.fillWidth: true
            
            Text {
                id: label
                text: lang.appearance?.clock_position_label || "Vị trí đồng hồ:"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: 18
                    bold: true
                }
                Layout.preferredWidth: 200
            }
            
            Item { Layout.fillWidth: true }
        }
        
        // Grid container lớn hơn
        Rectangle {
            id: positionContainer
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(parent.width * 0.8, 400)
            color: "transparent"
            
            Grid {
                id: positionGrid
                anchors.centerIn: parent
                columns: 3
                rows: 3
                spacing: 25
                
                // Hàng 1
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "topLeft"
                    isSelected: Settings.clock.positionWidget === "topLeft"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ top: true, left: true })
                    onClicked: {
                        Settings.clock.positionWidget = "topLeft"
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "top"
                    isSelected: Settings.clock.positionWidget === "top"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ top: true, hCenter: true })
                    onClicked: {
                        Settings.clock.positionWidget = "top"
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "topRight"
                    isSelected: Settings.clock.positionWidget === "topRight"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ top: true, right: true })
                    onClicked: {
                        Settings.clock.positionWidget = "topRight"
                    }
                }
                
                // Hàng 2
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "left"
                    isSelected: Settings.clock.positionWidget === "left"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ left: true, vCenter: true })
                    onClicked: {
                        Settings.clock.positionWidget = "left"
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "center"
                    isSelected: Settings.clock.positionWidget === "center"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ hCenter: true, vCenter: true })
                    onClicked: {
                        Settings.clock.positionWidget = "center"
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "right"
                    isSelected: Settings.clock.positionWidget === "right"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ right: true, vCenter: true })
                    onClicked: {
                        Settings.clock.positionWidget = "right"
                    }
                }
                
                // Hàng 3
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "bottomLeft"
                    isSelected: Settings.clock.positionWidget === "bottomLeft"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ bottom: true, left: true })
                    onClicked: {
                        Settings.clock.positionWidget = "bottomLeft"
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "bottom"
                    isSelected: Settings.clock.positionWidget === "bottom"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ bottom: true, hCenter: true })
                    onClicked: {
                        Settings.clock.positionWidget = "bottom"
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "bottomRight"
                    isSelected: Settings.clock.positionWidget === "bottomRight"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ bottom: true, right: true })
                    onClicked: {
                        Settings.clock.positionWidget = "bottomRight"
                    }
                }
            }
        }
        
        // Phần mô tả vị trí được chọn
        Item {
            id: positionDescription
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            
            Text {
                anchors.centerIn: parent
                text: {
                    var pos = Settings.clock.positionWidget;
                    var descriptions = {
                        "topLeft": "Trên cùng bên trái",
                        "top": "Trên cùng giữa",
                        "topRight": "Trên cùng bên phải",
                        "left": "Bên trái giữa",
                        "center": "Chính giữa màn hình",
                        "right": "Bên phải giữa",
                        "bottomLeft": "Dưới cùng bên trái",
                        "bottom": "Dưới cùng giữa",
                        "bottomRight": "Dưới cùng bên phải"
                    };
                    return descriptions[pos] || "Vị trí: " + pos;
                }
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: 18
                }
            }
        }
    }
}
