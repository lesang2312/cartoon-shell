import QtQuick
import qs.services
import qs.components

Item {
  id: header
  signal closeClicked

  property var theme: ThemeService.theme

  property var lang: LanguageService.translations

  CustomText{
    anchors.centerIn: parent

    name: lang?.ram?.panel_title || "Quản lí Ram"
    size: "2xl"
    isBold: true

  }
  CloseButton{
    onClicked: VisibleService.togglePanel("ram")
  }
}
