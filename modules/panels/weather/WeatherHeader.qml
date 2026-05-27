import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services

Item {
  id: headerCard

  Layout.fillWidth: true
  height: ScalerService.s(70)

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
