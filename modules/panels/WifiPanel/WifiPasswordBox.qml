import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services

Rectangle {
    id: passwordBox
    property var theme : ThemeService.theme

    property var lang
    property var wifiManager
    property var networkData
    
    property bool showPassword: false
    property bool hasError: false
    property string errorMessage: ""
    property bool hasSavedPassword: networkData.isConnected
    
    color: theme.primary.dim_background
    radius: 12
    height: visible ? (hasError ? 150 : 100) : 0
    border.width: 2
    border.color: theme.normal.blue
    
    Behavior on height {
        NumberAnimation { duration: 200 }
    }

    Component.onCompleted: {
        if (visible && networkData.isConnected) {
            wifiManager.getSavedPassword(networkData.ssid)
        }
    }

    onVisibleChanged: {
        if (visible && networkData.isConnected) {
            wifiManager.getSavedPassword(networkData.ssid)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Rectangle {
            Layout.fillWidth: true
            height: 30
            visible: passwordBox.hasError
            color: theme.normal.red
            radius: 6
            Text {
                anchors.centerIn: parent
                text: "❌ " + passwordBox.errorMessage
                color: theme.primary.foreground
                font.pixelSize: 12
                font.family: "ComicShannsMono Nerd Font"
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: passwordBox.hasSavedPassword

            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: theme.primary.background
                radius: 8
                border.color: theme.normal.blue
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: passwordBox.showPassword ? wifiManager.currentPassword : "••••••••"
                    font.family: "ComicShannsMono Nerd Font"
                    color: theme.primary.foreground
                    font.pixelSize: 14
                }
            }

            Button {
                width: 40
                height: 40
                font.family: "ComicShannsMono Nerd Font"
                background: Rectangle {
                    color: parent.down ? theme.button.background_select :
                           parent.hovered ? theme.button.background_select : theme.button.background
                    radius: 8
                }
                contentItem: Text {
                    text: passwordBox.showPassword ? "👁️" : "🙈"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 18
                }
                onClicked: {
                    passwordBox.showPassword = !passwordBox.showPassword
                }
            }

            Button {
                text: lang?.wifi?.forget || "Quên"
                font.family: "ComicShannsMono Nerd Font"
                background: Rectangle {
                    color: parent.down ? theme.normal.red :
                           parent.hovered ? Qt.lighter(theme.normal.red, 1.2) : theme.normal.red
                    radius: 8
                }
                contentItem: Text {
                    text: parent.text
                    color: theme.primary.foreground
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    wifiManager.forgetPassword(networkData.ssid)
                    passwordBox.hasSavedPassword = false
                    wifiManager.openSsid = ""
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: !passwordBox.hasSavedPassword

            TextField {
                id: wifiPassword
                Layout.fillWidth: true
                placeholderText: networkData.security === "Open" ? 
                               (lang?.wifi?.no_password || "Không cần mật khẩu") : 
                               (lang?.wifi?.enter_password || "Nhập mật khẩu")
                echoMode: passwordBox.showPassword ? TextInput.Normal : TextInput.Password
                enabled: networkData.security !== "Open"
                font.family: "ComicShannsMono Nerd Font"
                color: theme.primary.foreground
                background: Rectangle {
                    color: theme.primary.background
                    radius: 8
                    border.color: theme.normal.blue
                    border.width: 1
                }

                onActiveFocusChanged: {
                    wifiManager.userTyping = activeFocus
                }
            }

            Button {
                width: 40
                height: 40
                visible: networkData.security !== "Open"
                font.family: "ComicShannsMono Nerd Font"
                background: Rectangle {
                    color: parent.down ? theme.button.background_select :
                           parent.hovered ? theme.button.background_select : theme.button.background
                    radius: 8
                }
                contentItem: Text {
                    text: passwordBox.showPassword ? "👁️" : "🙈"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 18
                }
                onClicked: {
                    passwordBox.showPassword = !passwordBox.showPassword
                }
            }

            Button {
                text: lang?.wifi?.connect || "Kết nối"
                font.family: "ComicShannsMono Nerd Font"
                background: Rectangle {
                    color: parent.down ? theme.normal.blue :
                           parent.hovered ? theme.bright.blue : theme.normal.blue
                    radius: 8
                }
                contentItem: Text {
                    text: parent.text
                    color: theme.primary.foreground
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    if (wifiPassword.text.trim().length === 0 && networkData.security !== "Open") {
                        passwordBox.hasError = true
                        passwordBox.errorMessage = lang?.wifi?.password_required || "Vui lòng nhập mật khẩu"
                        return
                    }

                    passwordBox.hasError = false
                    passwordBox.errorMessage = ""

                    wifiManager.connectToWifi(networkData.ssid, wifiPassword.text)

                    Qt.callLater(function() {
                        if (wifiManager.connectionError) {
                            passwordBox.hasError = true
                            passwordBox.errorMessage = lang?.wifi?.wrong_password || "Mật khẩu không đúng"
                        } else {
                            passwordBox.hasSavedPassword = true
                            wifiManager.openSsid = ""
                        }
                    })

                    wifiPassword.text = ""
                }
            }
        }
    }
}
