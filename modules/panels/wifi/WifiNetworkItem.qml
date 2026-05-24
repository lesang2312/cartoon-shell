import QtQuick
import QtQuick.Layouts
import "." as Com
import qs.services
import qs.components
import qs.commons

ColumnLayout {
  id: networkItem
  property var theme: ThemeService.theme
  property var lang: LanguageService.translations
  property var wifiManager
  property var networkData

  spacing: 4

  Rectangle {
    id: wifiItem
    width: parent.width
    Layout.fillWidth: true
    Layout.preferredHeight: 70
    color: mouseArea.containsMouse ? theme.button.background_select : (networkData.isConnected ? theme.button.background : theme.primary.dim_background)
    radius: Settings.appearance.radius2
    border.width: Settings.appearance.enableBorder ? 2 : 0
    border.color: networkData.isConnected ? theme.button.border : theme.normal.black

    RowLayout {
      anchors.margins: 8
      anchors.fill: parent

      ColumnLayout {
        CustomText {
          name: networkData.ssid
          size: "small"
          isBold: true
          textColor: networkData.isConnected ? theme.primary.foreground : theme.primary.foreground
        }
        CustomText {
          name: networkData.security + " • " + networkData.signal
          size: "xs"
          textColor: networkData.isConnected ? theme.button.text : theme.primary.dim_foreground
        }
      }
      Item{Layout.fillWidth: true}

      Rectangle {
        color: networkData.isConnected ? theme.normal.green : theme.button.background
        Layout.preferredHeight: iconItem.height
        Layout.preferredWidth: iconItem.height
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
    Layout.fillWidth: true
    Layout.preferredHeight: 70
    visible: networkItem.networkData.ssid === wifiManager.openSsid
    networkData: networkItem.networkData
    theme: networkItem.theme
    lang: networkItem.lang
    wifiManager: networkItem.wifiManager
    width: parent.width
  }
}
