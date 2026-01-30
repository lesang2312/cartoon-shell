import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.components
import "./appearance/" as Com
import "." as BarList

Item {
    id: rootAppearance
    property var theme : ThemeService.theme
    property var lang: currentLanguage
    property int currentTab: 0

    ListSettingsService {
        id: listSettingService
    }

    // Sử dụng StackLayout thay vì điều kiện phức tạp
    StackLayout {
        anchors.fill: parent
        currentIndex: panelManager.fullsetting ? 0 : 1

        // Layout cho chế độ fullsetting (sidebar + content)
        Item {
            RowLayout {
                anchors.fill: parent
                spacing: 0

                // Sidebar Navigation (fullsetting mode)
                BarList.BarListSettings {
                    currentIndex: rootAppearance.currentTab
                    onCategoryChanged: function(index) {
                        rootAppearance.currentTab = index
                    }
                    title: listSettingService.listCategories[1]?.categoryName || "Appearance"
                    listModal: listSettingService.listCategories[1]?.items || []
                    
                    Layout.preferredWidth: 260
                    Layout.fillHeight: true
                }

                // Main Content Area (fullsetting mode)
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 20
                    anchors.margins: 20

                    // StackLayout for tabs
                    StackLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        currentIndex: rootAppearance.currentTab

                        // Tab 0: Theme
                        Com.Theme {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        // Tab 1: Panel
                        Com.Panel{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        // Tab 2: Clock
                        Com.ClockTime {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        // Tab 3: Fonts
                        ColumnLayout {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: lang?.appearance?.fonts || "Fonts"
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 24
                                    bold: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: theme.primary.foreground
                                opacity: 0.3
                            }

                            // Fonts settings content
                            Text {
                                text: "Fonts settings content"
                                color: theme.primary.foreground
                            }
                        }

                        // Tab 4: Icons
                        ColumnLayout {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: lang?.appearance?.icons || "Icons"
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 24
                                    bold: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: theme.primary.foreground
                                opacity: 0.3
                            }

                            // Icons settings content
                            Text {
                                text: "Icons settings content"
                                color: theme.primary.foreground
                            }
                        }

                        // Tab 5: Effects
                        ColumnLayout {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: lang?.appearance?.effects || "Effects"
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 24
                                    bold: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: theme.primary.foreground
                                opacity: 0.3
                            }

                            // Effects settings content
                            Text {
                                text: "Effects settings content"
                                color: theme.primary.foreground
                            }
                        }

                        // Tab 6: Layout
                        ColumnLayout {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: lang?.appearance?.layout || "Layout"
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 24
                                    bold: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: theme.primary.foreground
                                opacity: 0.3
                            }

                            // Layout settings content
                            Text {
                                text: "Layout settings content"
                                color: theme.primary.foreground
                            }
                        }

                        // Tab 7: Wallpaper
                        Com.Wallpapers {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        // Tab 8: Advanced (nếu cần)
                        ColumnLayout {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: "Advanced"
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 24
                                    bold: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: theme.primary.foreground
                                opacity: 0.3
                            }

                            // Advanced settings content
                            Text {
                                text: "Advanced settings content"
                                color: theme.primary.foreground
                            }
                        }
                    }
                }
            }
        }

        // Layout cho chế độ minimal (only content with top nav)
        Item {
            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                // Top Navigation Bar (minimal mode)
                Rectangle {
                    id: minimalNav
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    
                    color: theme.primary.dim_background
                    radius: 12
                    border.color: theme.button.border
                    border.width: 2
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing:16
                        
                        Item { Layout.fillWidth: true } // Spacer
                        Repeater {
                            model: listSettingService.listCategories[1]?.items || []
                            
                            delegate: Rectangle {
                                id: minimalDelegate
                                Layout.fillHeight: true
                                Layout.preferredWidth: 42
                                radius: 8
                                
                                property bool selected: rootAppearance.currentTab === index
                                
                                color: theme.primary.background
                                
                                // Hiệu ứng scale
                                scale: mouseArea.containsPress ? 0.95 : 1.0
                                Behavior on scale { NumberAnimation { duration: 100 } }
                                
                                
                                // Icon
                                Image {
                                    anchors.centerIn: parent
                                    source: modelData.icon
                                    height: 32
                                    width: 32
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }
                                
                                
                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    
                                    onClicked: {
                                        rootAppearance.currentTab = index
                                    }
                                }
                            }
                        }
                        
                        Item { Layout.fillWidth: true } // Spacer
                    }
                }

                // Main Content Area (minimal mode)
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 20
                    anchors.margins: 20

                    // StackLayout for tabs - SAME AS ABOVE
                    StackLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        currentIndex: rootAppearance.currentTab

                        // Tab 0: Theme
                        Com.Theme {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        // Tab 1: Panel
                        Com.Panel{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        // Tab 2: Clock
                        Com.ClockTime {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        // Tab 3: Fonts
                        ColumnLayout {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: lang?.appearance?.fonts || "Fonts"
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 24
                                    bold: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: theme.primary.foreground
                                opacity: 0.3
                            }

                            // Fonts settings content
                            Text {
                                text: "Fonts settings content"
                                color: theme.primary.foreground
                            }
                        }

                        // Tab 4: Icons
                        ColumnLayout {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: lang?.appearance?.icons || "Icons"
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 24
                                    bold: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: theme.primary.foreground
                                opacity: 0.3
                            }

                            // Icons settings content
                            Text {
                                text: "Icons settings content"
                                color: theme.primary.foreground
                            }
                        }

                        // Tab 5: Effects
                        ColumnLayout {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: lang?.appearance?.effects || "Effects"
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 24
                                    bold: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: theme.primary.foreground
                                opacity: 0.3
                            }

                            // Effects settings content
                            Text {
                                text: "Effects settings content"
                                color: theme.primary.foreground
                            }
                        }

                        // Tab 6: Layout
                        ColumnLayout {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: lang?.appearance?.layout || "Layout"
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 24
                                    bold: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: theme.primary.foreground
                                opacity: 0.3
                            }

                            // Layout settings content
                            Text {
                                text: "Layout settings content"
                                color: theme.primary.foreground
                            }
                        }

                        // Tab 7: Wallpaper
                        Com.Wallpapers {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        // Tab 8: Advanced (nếu cần)
                        ColumnLayout {
                            width: parent.width
                            spacing: 20

                            Text {
                                text: "Advanced"
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 24
                                    bold: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: theme.primary.foreground
                                opacity: 0.3
                            }

                            // Advanced settings content
                            Text {
                                text: "Advanced settings content"
                                color: theme.primary.foreground
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("AppearanceSettings loaded")
    }
}
