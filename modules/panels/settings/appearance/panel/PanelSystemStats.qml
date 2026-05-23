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
  function changeStyle(nameSystem,style) {
    switch(nameSystem) {
      case "cpu": {
        Settings.bar.cpu = {
          "style": style,
          "active" : Settings.bar.cpu.active
        }
        return;
      }
      case "ram": {
        Settings.bar.ram = {
          "style": style,
          "active" : Settings.bar.ram.active
        }
        return;
      }
    }
  }
  CustomText {
    name: "System Stats"
    isBold: true
  }
  RowLayout {
    CustomText {
      name: "CPU"
    }
    Item{Layout.fillWidth: true}
    GridLayout {
      columns: 4
      rowSpacing: 12
      columnSpacing: 12

      Repeater {
        model: 8

        delegate: ButtonText {
          required property int index

          property int styleIndex: index + 1
          property bool selected: Settings.bar.cpu.style === styleIndex

          Layout.preferredHeight: 40
          Layout.preferredWidth: 80

          name: `Style ${styleIndex}`
          size: "xs"

          color: selected
          ? theme.button.background_select
          : theme.button.background

          textColor: selected
          ? theme.button.text
          : theme.primary.dim_foreground

          border.color: selected
          ? theme.button.border_select
          : theme.primary.foreground

          onClicked: {
            root.changeStyle("cpu", styleIndex)
          }
        }
      }
    }
  }
}
