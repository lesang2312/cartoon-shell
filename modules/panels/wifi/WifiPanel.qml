import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import qs.commons
import "." as Com

PanelWindow {
    id: wifiPanel

    implicitWidth: 450
    implicitHeight: 800

    anchors {
        // Anchor theo vị trí của bar
        left: Settings.bar.position === "left"
        right: Settings.bar.position === "right" || Settings.bar.position === "top" || Settings.bar.position === "bottom"
        top: Settings.bar.position === "top"
        bottom: Settings.bar.position === "left" || Settings.bar.position === "right" || Settings.bar.position === "bottom"
    }

    margins {
        top: Settings.bar.position === "top" ? 10 : 0
        bottom: (Settings.bar.position === "bottom" || Settings.bar.position === "left" || Settings.bar.position === "right") ? 10 : 0
        left: Settings.bar.position === "left" ? 10 : 0
        right: (Settings.bar.position === "right" || Settings.bar.position === "top" || Settings.bar.position === "bottom") ? (sizes.anchorMargin || 10) : 0
    }

    color: "transparent"
    focusable: true
    Com.WifiManager {
        id: wifiManager
    }

    property var theme: ThemeService.theme
    property var lang: LanguageService.translations

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: theme.primary.background
        border.width: 2
        border.color: theme.button.border

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Com.WifiHeader {
                Layout.fillWidth: true
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiManager
            }

            Com.WifiStatus {
                Layout.fillWidth: true
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiManager
            }

            Com.WifiNetworkList {
                Layout.fillWidth: true
                Layout.fillHeight: true
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiManager
                visible: wifiManager.wifiEnabled
            }

            Com.WifiEmptyState {
                Layout.fillWidth: true
                Layout.fillHeight: true
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                visible: !wifiManager.wifiEnabled
            }
        }
    }
}
