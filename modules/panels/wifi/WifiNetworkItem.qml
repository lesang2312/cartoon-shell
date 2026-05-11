import QtQuick
import QtQuick.Layouts
import "." as Com
import qs.services
import qs.components

Column {
  id: networkItem
  property var theme: ThemeService.theme
  property var lang: LanguageService.translations
  property var wifiManager
  property var networkData

  width: parent.width
  spacing: 4

  Rectangle {
    id: wifiItem
    width: parent.width
    height: 70
    radius: 12
    color: mouseArea.containsMouse ? theme.button.background_select : (networkData.isConnected ? theme.button.background : theme.primary.dim_background)
    border.width: 2
    border.color: networkData.isConnected ? theme.button.border : theme.normal.black

    RowLayout {
      anchors.margins: 8
      anchors.fill: parent

      Column {
        Layout.fillWidth: true
        Text {
          text: networkData.ssid
          font.pixelSize: 18
          font.bold: true
          color: networkData.isConnected ? theme.primary.foreground : theme.primary.foreground
          font.family: "ComicShannsMono Nerd Font"
        }
        Text {
          text: networkData.security + " • " + networkData.signal
          font.pixelSize: 13
          color: networkData.isConnected ? theme.button.text : theme.primary.dim_foreground
          font.family: "ComicShannsMono Nerd Font"
        }
      }

      Rectangle {
        color: networkData.isConnected ? theme.normal.green : theme.button.background
        implicitWidth: iconItem.height
        implicitHeight: iconItem.height
        radius: 16
        IconText{
          anchors.centerIn: parent
          id: iconItem
          name: networkData.isConnected ? "check" : networkData.saved_password != "--" ? "lock_open" : "lock"
          size: "small"
          textColor: networkData.isConnected ? theme.primary.background : theme.button.text
        }

      }

    }

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        if (wifiManager.openSsid === networkData.ssid) {
          wifiManager.openSsid = "";
        } else {
          wifiManager.openSsid = networkData.ssid;
        }
      }
    }
  }

  Com.WifiPasswordBox {
    visible: networkItem.networkData.ssid === wifiManager.openSsid
    networkData: networkItem.networkData
    theme: networkItem.theme
    lang: networkItem.lang
    wifiManager: networkItem.wifiManager
    width: parent.width
  }
}
