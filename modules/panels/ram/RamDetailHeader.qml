import QtQuick
import qs.services
import qs.components

Item {
  id: header
  signal closeClicked

  property var theme: ThemeService.theme

  property var lang: LanguageService.translations
  property real animationProgress: 0

  CustomText{
    anchors.centerIn: parent

    name: lang?.ram?.panel_title || "Quản lí Ram"
    size: "2xl"
    isBold: true
    opacity: root.animationProgress > 0.1 ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }

  }
  CloseButton{
    onClicked: VisibleService.togglePanel("ram")
    opacity: root.animationProgress > 0.15 ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }
  }
}
