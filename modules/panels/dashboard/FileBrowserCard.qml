import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import "." as Com
import qs.services
import qs.commons

Rectangle {
  id: root

  Layout.preferredWidth: ScalerService.s(200)
  Layout.preferredHeight: ScalerService.s(220)

  color: theme.primary.background
  border.color: theme.button.border
  property real animationProgress: 0
  radius: ScalerService.s(Settings.appearance.radius1)
  border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: ScalerService.s(15)
    spacing: ScalerService.s(8)

    Com.FileItem {
      icon: "filebrowser/documents.png"
      label: "Documents"
      animationProgress: root.animationProgress
      revealThreshold: 1
    }
    Com.FileItem {
      icon: "filebrowser/downloads.png"
      label: "Downloads"
      animationProgress: root.animationProgress
      revealThreshold: 1.1
    }
    Com.FileItem {
      icon: "filebrowser/music.png"
      label: "Musics"
      animationProgress: root.animationProgress
      revealThreshold: 1.2
    }
    Com.FileItem {
      icon: "filebrowser/pictures.png"
      label: "Pictures"
      animationProgress: root.animationProgress
      revealThreshold: 1.3
    }
    Com.FileItem {
      icon: "filebrowser/config.png"
      label: "~/.config"
      animationProgress: root.animationProgress
      revealThreshold: 1.4
    }
    Com.FileItem {
      icon: "filebrowser/local.png"
      label: "~/.local"
      animationProgress: root.animationProgress
      revealThreshold: 1.5
    }
  }
}
