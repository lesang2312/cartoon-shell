import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services
import qs.components

Rectangle {
  id: passwordBox
  property var theme: ThemeService.theme

  property var lang: LanguageService.translations
  property var wifiManager
  property var networkData

  property bool showPassword: false
  property bool hasError: false
  property string errorMessage: ""
  property bool hasSavedPassword: networkData.saved_password && networkData.saved_password !== "--" && networkData.saved_password !== ""
  property bool isConnected: networkData.ssid === wifiManager.connectedWifi

  color: theme.primary.dim_background
  radius: 12
  height: visible ? (hasError ? 120 : 80) : 0
  border.width: 2
  border.color: theme.normal.blue

  Behavior on height {
    NumberAnimation {
      duration: 200
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

    // Phần hiển thị mật khẩu đã lưu (luôn hiển thị nếu có saved password)
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
          text: passwordBox.showPassword ? networkData.saved_password : "••••••••"
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
          color: parent.down ? theme.button.background_select : parent.hovered ? theme.button.background_select : theme.button.background
          radius: 8
        }
        contentItem: IconText{
          name: passwordBox.showPassword ? "visibility" : "visibility_off"
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          size: "small"
        }
        onClicked: {
          passwordBox.showPassword = !passwordBox.showPassword;
        }
      }

      // Nút kết nối (hiển thị khi chưa kết nối)
      Button {
        height: 40
        text: lang?.wifi?.connect || "Kết nối"
        visible: !passwordBox.isConnected
        font.family: "ComicShannsMono Nerd Font"
        background: Rectangle {
          color: parent.down ? theme.normal.blue : parent.hovered ? theme.bright.blue : theme.normal.blue
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
          // Kết nối với mật khẩu đã lưu
          wifiManager.connectToWifi(networkData.ssid, networkData.saved_password);

          Qt.callLater(function () {
              if (wifiManager.connectionError) {
                passwordBox.hasError = true;
                passwordBox.errorMessage = lang?.wifi?.wrong_password || "Mật khẩu không đúng";
                // Nếu sai mật khẩu, xóa saved password để người dùng nhập lại
                networkData.saved_password = "";
                passwordBox.hasSavedPassword = false;
              }
          });
        }
      }

      // Nút quên mật khẩu
      Button {
        height: 40
        text: lang?.wifi?.forget || "Quên"
        font.family: "ComicShannsMono Nerd Font"
        background: Rectangle {
          color: parent.down ? theme.normal.red : parent.hovered ? Qt.lighter(theme.normal.red, 1.2) : theme.normal.red
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
          wifiManager.forgetPassword(networkData.ssid);
          passwordBox.hasSavedPassword = false;
          networkData.saved_password = "";
          wifiManager.openSsid = "";
          wifiManager.scanWifiNetworks();
        }
      }
    }

    // Phần nhập mật khẩu mới (khi chưa có saved password)
    RowLayout {
      Layout.fillWidth: true
      spacing: 8
      visible: !passwordBox.hasSavedPassword

      TextField {
        id: wifiPassword
        Layout.fillWidth: true
        placeholderText: networkData.security === "Open" ? (lang?.wifi?.no_password || "Không cần mật khẩu") : (lang?.wifi?.enter_password || "Nhập mật khẩu")
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
          wifiManager.userTyping = activeFocus;
        }
      }

      Button {
        width: 40
        height: 40
        visible: networkData.security !== "Open"
        font.family: "ComicShannsMono Nerd Font"
        background: Rectangle {
          color: parent.down ? theme.button.background_select : parent.hovered ? theme.button.background_select : theme.button.background
          radius: 8
        }
        contentItem: IconText{
          name: passwordBox.showPassword ? "visibility" : "visibility_off"
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          size: "small"
        }
        onClicked: {
          passwordBox.showPassword = !passwordBox.showPassword;
        }
      }

      Button {
        height: 40
        text: lang?.wifi?.connect || "Kết nối"
        font.family: "ComicShannsMono Nerd Font"
        background: Rectangle {
          color: parent.down ? theme.normal.blue : parent.hovered ? theme.bright.blue : theme.normal.blue
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
          var password = wifiPassword.text.trim();

          if (password.length === 0 && networkData.security !== "Open") {
            passwordBox.hasError = true;
            passwordBox.errorMessage = lang?.wifi?.password_required || "Vui lòng nhập mật khẩu";
            return;
          }

          passwordBox.hasError = false;
          passwordBox.errorMessage = "";

          wifiManager.connectToWifi(networkData.ssid, password);

          Qt.callLater(function () {
              if (wifiManager.connectionError) {
                passwordBox.hasError = true;
                passwordBox.errorMessage = lang?.wifi?.wrong_password || "Mật khẩu không đúng";
              } else {
                // Lưu mật khẩu sau khi kết nối thành công
                if (password) {
                  networkData.saved_password = password;
                  passwordBox.hasSavedPassword = true;
                }
                wifiManager.openSsid = "";
              }
          });

          wifiPassword.text = "";
        }
      }
    }
  }
}
