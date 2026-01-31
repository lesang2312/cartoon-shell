// components/Settings/GeneralSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.components
import "./general/" as Com
import "./appearance/" as AppCom

Item {
    id: root
    property var theme: ThemeService.theme
    property var lang: currentLanguage
    property int currentTab: 0
    
    // Timer để reload ngôn ngữ
    property Timer reloadTimer: Timer {
        interval: 30
        repeat: false
        onTriggered: languageLoader.loadLanguage()
    }
    
    ListSettingsService {
        id: listSettingService
    }
    
    // Chỉ giữ lại giao diện minimal mode
    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        
        // Top Navigation Bar
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
                spacing: 16
                
                Item { Layout.fillWidth: true } // Spacer
                Repeater {
                    model: listSettingService.listCategories[0]?.items || []
                    
                    delegate: Item {
                        id: minimalDelegate
                        Layout.fillHeight: true
                        Layout.preferredWidth: 42
                        
                        property bool selected: root.currentTab === index
                        
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
                                root.currentTab = index
                            }
                        }
                    }
                }
                
                Item { Layout.fillWidth: true } // Spacer
            }
        }
        
        // Main Content Area
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20
            anchors.margins: 20
            
            // StackLayout for tabs
            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: root.currentTab
                
                // Tab 0: Language & Region
                Com.LanguageRegion {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                
                // Tab 1: Date & Time
                ScrollView {
                    clip: true
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    
                    ColumnLayout {
                        width: parent.width
                        spacing: 20
                        anchors.margins: 20
                        
                        Text {
                            text: lang?.general?.date_time || "Date & Time"
                            color: theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 24
                                bold: true
                            }
                            Layout.alignment: Qt.AlignLeft
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: theme.primary.foreground
                            opacity: 0.3
                        }
                        
                        // Nội dung Date & Time ở đây
                        Text {
                            text: "Date & Time settings content"
                            color: theme.primary.foreground
                            Layout.alignment: Qt.AlignLeft
                        }
                    }
                }
                
                // Tab 2: Session
                ScrollView {
                    clip: true
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    
                    ColumnLayout {
                        width: parent.width
                        spacing: 20
                        anchors.margins: 20
                        
                        Text {
                            text: lang?.general?.session || "Session"
                            color: theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 24
                                bold: true
                            }
                            Layout.alignment: Qt.AlignLeft
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: theme.primary.foreground
                            opacity: 0.3
                        }
                        
                        // Nội dung Session ở đây
                        Text {
                            text: "Session settings content"
                            color: theme.primary.foreground
                            Layout.alignment: Qt.AlignLeft
                        }
                    }
                }
                
                // Tab 3: Behavior
                ScrollView {
                    clip: true
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    
                    ColumnLayout {
                        width: parent.width
                        spacing: 20
                        anchors.margins: 20
                        
                        Text {
                            text: lang?.general?.behavior || "Behavior"
                            color: theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 24
                                bold: true
                            }
                            Layout.alignment: Qt.AlignLeft
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: theme.primary.foreground
                            opacity: 0.3
                        }
                        
                        // Nội dung Behavior ở đây
                        Text {
                            text: "Behavior settings content"
                            color: theme.primary.foreground
                            Layout.alignment: Qt.AlignLeft
                        }
                    }
                }
                
                // Tab 4: Notifications
                ScrollView {
                    clip: true
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    
                    ColumnLayout {
                        width: parent.width
                        spacing: 20
                        anchors.margins: 20
                        
                        Text {
                            text: lang?.general?.notifications || "Notifications"
                            color: theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 24
                                bold: true
                            }
                            Layout.alignment: Qt.AlignLeft
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: theme.primary.foreground
                            opacity: 0.3
                        }
                        
                        // Nội dung Notifications ở đây
                        Text {
                            text: "Notifications settings content"
                            color: theme.primary.foreground
                            Layout.alignment: Qt.AlignLeft
                        }
                    }
                }
                
                // Tab 5: Privacy
                ScrollView {
                    clip: true
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    
                    ColumnLayout {
                        width: parent.width
                        spacing: 20
                        anchors.margins: 20
                        
                        Text {
                            text: lang?.general?.privacy || "Privacy"
                            color: theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 24
                                bold: true
                            }
                            Layout.alignment: Qt.AlignLeft
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: theme.primary.foreground
                            opacity: 0.3
                        }
                        
                        // Nội dung Privacy ở đây
                        Text {
                            text: "Privacy settings content"
                            color: theme.primary.foreground
                            Layout.alignment: Qt.AlignLeft
                        }
                    }
                }
            }
        }
    }
    
    Component.onCompleted: {
        console.log("GeneralSettings loaded")
    }
}
