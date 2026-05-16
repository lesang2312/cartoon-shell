import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Widgets
import qs.services
import qs.commons
import qs.components

Rectangle {
  id: root

  property var theme : ThemeService.theme
  property real animationProgress: 0

  Loader {
    source: "../../dialogs/FileDialog.qml"
    active: VisibleService.filedialog

    onLoaded: {
      item.visible = Qt.binding(function () {
          return VisibleService.filedialog;
      });

      item.fileOpened.connect(function(fileUrl) {
          Settings.dashboard.urlAvatar = fileUrl
          VisibleService.togglePanel("filedialog")
      })
    }
  }

  Layout.fillWidth: true
  Layout.fillHeight: true
  radius: 28
  color: theme.primary.background
  border.width: 3
  border.color: theme.button.border

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 20
    spacing: 15

    // Avatar
    Rectangle {
      id: avatarRoot

      Layout.alignment: Qt.AlignHCenter

      width: 120
      height: 120
      radius: 60

      color: "#2a2a2a"

      property bool hovered: false

      scale: hovered ? 1.05 : 1.0

      Behavior on scale {
        NumberAnimation {
          duration: 120
        }
      }

      ClippingRectangle {
        id: albumArtContainer

        opacity: root.animationProgress > 0.1 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
        anchors.fill: parent
        radius: width / 2

        color: theme.primary.dim_background

        border.color:  theme.primary.foreground

        border.width: mouseAreaAvt.containsMouse ? 2 : 1

        Behavior on border.width {
          NumberAnimation {
            duration: 120
          }
        }

        Behavior on border.color {
          ColorAnimation {
            duration: 120
          }
        }

        Image {
          anchors.fill: parent
          source: Settings.dashboard.urlAvatar
          ? Settings.dashboard.urlAvatar
          : "/home/long/Downloads/111423869.png"
          fillMode: Image.PreserveAspectCrop
          smooth: true
        }
        Rectangle {
          anchors.fill: parent

          color: "black"
          opacity: mouseAreaAvt.containsMouse ? 0.4 : 0

          Behavior on opacity {
            NumberAnimation {
              duration: 150
            }
          }
        }
        IconText{
          visible: avatarRoot.hovered ? true : false
          name: "frame_person"

          anchors.centerIn: parent

          font.pixelSize: mouseAreaAvt.containsMouse ? 58 : 52

          Behavior on font.pixelSize {
            NumberAnimation {
              duration: 150
            }
          }
        }
      }

      MouseArea {
        id: mouseAreaAvt
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: VisibleService.togglePanel("filedialog")

        onEntered: avatarRoot.hovered = true
        onExited: avatarRoot.hovered = false
      }
    }

    // User Name
    Label {
      Layout.alignment: Qt.AlignHCenter
      text: Settings.dashboard.fullname
      color: theme.primary.foreground
      font.pixelSize: 40
      font.bold: true
      font.family: "ComicShannsMono Nerd Font"
      opacity: root.animationProgress > 0.15 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
    }

    // User Handle
    Label {
      Layout.alignment: Qt.AlignHCenter
      text: Settings.dashboard.username
      color: theme.primary.foreground
      font.pixelSize: 24
      font.family: "ComicShannsMono Nerd Font"
      opacity: root.animationProgress > 0.2 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
    }
  }
}
