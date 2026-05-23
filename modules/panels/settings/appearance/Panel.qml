import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.components
import qs.commons
import "./panel/" as Com

Item {
  id: root
  property var theme: ThemeService.theme
  property var lang: LanguageService.translations

  ScrollView {
    id: scrollView
    anchors.fill: parent
    clip: true
    anchors.margins: 20

    ScrollBar.vertical.policy: ScrollBar.AsNeeded
    ScrollBar.horizontal.policy: ScrollBar.AsNeeded

    ColumnLayout {
      width: scrollView.availableWidth
      spacing: 25

      // Header
      HeaderSettings {
        name: root.lang?.appearance?.panel || "Panel"
      }

      // Separator
      Rectangle {
        Layout.fillWidth: true
        height: 1
        color: theme.primary.foreground
        opacity: 0.2
        Layout.bottomMargin: 5
      }

      // Panel Position Settings
      Com.PanelPositionSelector{}
      Com.PanelSystemStats{}

      // Spacer
      Item {
        Layout.fillHeight: true
        Layout.minimumHeight: 20
      }
    }
  }
}
