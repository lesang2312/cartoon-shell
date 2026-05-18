import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services

Item {
  id: headerCard

  property var theme: ThemeService.theme
  property var lang: LanguageService.translations

  Layout.fillWidth: true
  height: 70

  CustomText {
    name: lang?.weather?.title || "Thời Tiết"
    size: "2xl"
    isBold: true
    anchors.centerIn: parent
  }
  CloseButton{
    onClicked: VisibleService.togglePanel("weather")
  }
}
