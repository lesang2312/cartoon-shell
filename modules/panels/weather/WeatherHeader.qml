import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services

Item {
  id: headerCard

  CustomText {
    name: lang?.weather?.title || "Thời Tiết"
    size: "large"
    isBold: true
    anchors.centerIn: parent
  }
  CloseButton{
    onClicked: VisibleService.togglePanel("weather")
  }
}
