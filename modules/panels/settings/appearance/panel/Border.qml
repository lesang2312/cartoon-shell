import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
import qs.commons

ColumnLayout {
  id: root
  spacing: 20
  Layout.fillWidth: true
  property var theme: ThemeService.theme
  property var lang: LanguageService.translations
  RowLayout {
    CustomText{
      name: "enable border: "
    }
    Item{
      Layout.fillWidth: true
    }
    CustomToggleSwitch {
      adapter: Settings.appearance.enableBorder
      onClicked: {
        Settings.appearance.enableBorder = !Settings.appearance.enableBorder
      }
    }

  }

}
