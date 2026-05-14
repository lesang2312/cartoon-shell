import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import qs.services
import qs.components

Rectangle {
  id: root
  property int emailCount: 230
  property var theme: ThemeService.theme

  Layout.fillWidth: true
  Layout.fillHeight: true
  radius: 28
  color: theme.primary.background
  border.width: 3
  border.color: theme.button.border

  RowLayout {
    anchors.centerIn: parent
    spacing: 20

    Image {
      source: "../../../assets/workspace/pacman.png"
      Layout.preferredWidth: 48
      Layout.preferredHeight: 48
      fillMode: Image.PreserveAspectFit
      smooth: true
    }

    CustomText{
      name: "820"
      isBold: true
    }
  }
  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: {
      VisibleService.togglePanel("packagePanel")
    }
  }
}
