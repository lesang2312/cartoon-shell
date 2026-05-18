import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import "." as Com
import qs.services

Rectangle {
  id: root

  Layout.preferredWidth: 200
  Layout.preferredHeight: 220
  radius: 28
  property var theme: ThemeService.theme

  color: theme.primary.background
  border.color: theme.button.border
  property real animationProgress: 0
  border.width: 3
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 15
    spacing: 8

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
