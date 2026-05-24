import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Io
import qs.services
import qs.commons
import qs.components

Rectangle {
  id: root
  property string image: ""
  property string linkSocial: ""
  property color bgColor: "white"
  property real hoverScale: 1.2 // Tỷ lệ phóng to khi hover
  property var theme : ThemeService.theme
  property real revealThreshold: 0
  property real animationProgress: 0

  Layout.fillHeight: true
  Layout.preferredWidth: height
  color: bgColor
  radius: Settings.appearance.radius1
  border.width: Settings.appearance.enableBorder ? 3 : 0
  border.color: theme.button.border
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  Process { id: linkProcess }

  // Hiệu ứng chuyển đổi mượt mà
  Behavior on scale {
    NumberAnimation {
      duration: 150
      easing.type: Easing.OutCubic
    }
  }

  Behavior on color {
    ColorAnimation {
      duration: 150
      easing.type: Easing.OutCubic
    }
  }

  Behavior on border.color {
    ColorAnimation {
      duration: 150
      easing.type: Easing.OutCubic
    }
  }

  IconImage {
    path: image
    anchors.centerIn: parent
    size: "xl"
    opacity: root.animationProgress > root.revealThreshold ? 1 : 0
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: {
      linkProcess.command = ["xdg-open", linkSocial]
      linkProcess.startDetached()
      // Bạn có thể thêm hành động khi click ở đây
    }
  }

}
