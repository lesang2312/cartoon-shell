import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import qs.services
import qs.commons
import qs.components

Rectangle {
  id: root
  color: theme.primary.background
  border.color: theme.button.border
  border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
  radius: ScalerService.s(Settings.appearance.radius2)

  property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"

  // UI Layout
  Loader {
    anchors.fill: parent
    anchors.margins: isVertical ? ScalerService.s(8) : ScalerService.s(10)
    sourceComponent: isVertical ? verticalLayout : horizontalLayout
  }

  Component {
    id: horizontalLayout

    RowLayout {
      anchors.fill: parent
      spacing: ScalerService.s(12)

      // Song info with marquee effect
      ColumnLayout {
        id: songInfoColumn
        Layout.fillWidth: true
        spacing: 0

        // Container for song title with marquee effect
        Item {
          id: songContainer
          Layout.fillWidth: true
          Layout.preferredHeight: ScalerService.s(23)
          clip: true

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: {
              VisibleService.togglePanel("music");
            }
            onEntered: songContainer.opacity = 0.8
            onExited: songContainer.opacity = 1.0
          }

          Text {
            id: songText
            text: Players.mprisPlayer?.trackTitle ?? "Not Playing"
            color: theme.primary.foreground
            font.family: "ComicShannsMono Nerd Font"
            font.pixelSize: ScalerService.s(16)

            property bool needsMarquee: width > songContainer.width

            x: 0

            SequentialAnimation on x {
              id: marqueeAnimation
              running: songText.needsMarquee
              loops: Animation.Infinite

              // Pause at start
              PauseAnimation {
                duration: 2000
              }

              // Scroll left
              NumberAnimation {
                to: -(songText.width - songContainer.width)
                duration: Math.max(2000, (songText.width - songContainer.width) * 20)
                easing.type: Easing.Linear
              }

              // Pause at end
              PauseAnimation {
                duration: 2000
              }

              // Scroll back
              NumberAnimation {
                to: 0
                duration: Math.max(2000, (songText.width - songContainer.width) * 20)
                easing.type: Easing.Linear
              }
            }
          }

          Behavior on opacity {
            NumberAnimation {
              duration: 100
            }
          }
        }

        // Artist name
        CustomText {
          name: Players.mprisPlayer ? (Players.mprisPlayer.trackArtist || "Unknown Artist") : "Unknown Artist"
          textColor: theme.primary.dim_foreground
          size: "xs"
          elide: Text.ElideRight
          Layout.fillWidth: true
        }
      }

      // Controls
      Item {
        Layout.fillHeight: true
        Layout.preferredWidth: ScalerService.s(120)

        RowLayout {
          id: controlsRow

          anchors.centerIn: parent
          spacing: ScalerService.s(2)

          ButtonIconText {
            name: "skip_previous"
            size: "normal"

            Layout.alignment: Qt.AlignVCenter
            onClicked: Players?.mprisPlayer.previous()

          }
          ButtonIconText {
            name: Players.mprisPlayer && Players.mprisPlayer.isPlaying
            ? "pause"
            : "play_arrow"
            size: "normal"

            Layout.alignment: Qt.AlignVCenter
            onClicked: Players?.mprisPlayer.togglePlaying()

          }
          ButtonIconText {
            name: "skip_next"
            size: "normal"

            Layout.alignment: Qt.AlignVCenter
            onClicked: Players?.mprisPlayer.next()

          }

        }
      }
    }
  }

  Component {
    id: verticalLayout

    ColumnLayout {
      anchors.fill: parent
      spacing: ScalerService.s(8)
      Item {

        Layout.fillWidth: true
        Layout.fillHeight: true

        // Xoay toàn bộ container 90 độ để text chạy dọc
        Item {
          anchors.centerIn: parent
          width: parent.height  // Đảo width và height
          height: parent.width
          rotation: -90
          transformOrigin: Item.Center
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: VisibleService.togglePanel("music")
            onEntered: parent.opacity = 0.8
            onExited: parent.opacity = 1.0
          }

          // Text container bên trong (đã xoay)
          ColumnLayout {
            anchors.fill: parent
            spacing: ScalerService.s(2)
            clip: true

            // Song title
            Item {
              Layout.fillWidth: true
              Layout.preferredHeight: ScalerService.s(10)

              Text {
                id: songTextVertical
                text: Players.mprisPlayer?.trackTitle ?? "Not Playing"
                color: theme.primary.foreground
                font.family: "ComicShannsMono Nerd Font"
                font.pixelSize: ScalerService.s(12)
                width: parent.width

                // Marquee effect ngang (sẽ thành dọc sau khi xoay)
                x: 0

                property bool needsMarquee: contentHeight > parent.height

                SequentialAnimation on y {
                  id: artistMarqueeAnimation
                  running: artistTextVertical.needsMarquee
                  loops: Animation.Infinite

                  PauseAnimation {
                    duration: 2000
                  }
                  NumberAnimation {
                    to: -(artistTextVertical.contentHeight - parent.height)
                    duration: Math.max(2000, (artistTextVertical.contentHeight - parent.height) * 20)
                    easing.type: Easing.Linear
                  }
                  PauseAnimation {
                    duration: 2000
                  }
                  NumberAnimation {
                    to: 0
                    duration: Math.max(2000, (artistTextVertical.contentHeight - parent.height) * 20)
                    easing.type: Easing.Linear
                  }
                }
              }

              Behavior on opacity {
                NumberAnimation {
                  duration: 100
                }
              }
            }

            // Artist name
            Text {
              text: Players.mprisPlayer?.trackTitle
              color: theme.primary.dim_foreground
              font.family: "ComicShannsMono Nerd Font"
              font.pixelSize: ScalerService.s(10)
              width: parent.width
              elide: Text.ElideRight
              horizontalAlignment: Text.AlignHCenter
            }
          }
        }
      }
      ColumnLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: ScalerService.s(8)
        Layout.preferredHeight: ScalerService.s(24)

        // Play/Pause button
        IconText {
          name: Players.mprisPlayer.isPlaying ? "pause" : "play_arrow"
          size: "small"

          Layout.alignment: Qt.AlignVCenter

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: Players?.mprisPlayer.togglePlaying()

            onEntered: parent.scale = 1.1
            onExited: parent.scale = 1.0
          }

          Behavior on scale {
            NumberAnimation {
              duration: 100
            }
          }
        }

      }
    }
  }

}
