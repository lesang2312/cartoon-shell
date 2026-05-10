import QtQuick
import qs.services
import qs.components

Item {
  id: header

  property var theme: ThemeService.theme
  property var lang: LanguageService.translations

  CustomText{
    name: lang?.calendar?.title || "Lịch"
    anchors.centerIn: parent

    isBold: true
    size: "large"

  }
  CloseButton{
    onClicked: VisibleService.togglePanel("calendar")
  }
}
