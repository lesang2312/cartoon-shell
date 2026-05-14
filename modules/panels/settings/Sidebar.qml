import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

Rectangle {
  id: sidebarSettings
  property var theme: ThemeService.theme
  property var lang: LanguageService.translations

  property int currentIndex: 0
  property bool anyItemHovered: false

  signal categoryChanged(int index)
  signal backRequested

  Layout.preferredWidth:  200
  Layout.fillHeight: true
  color: theme.primary.dim_background
  radius: 12
  border.color: theme.button.border
  border.width: 2

  // Behavior cho animation width
  Behavior on Layout.preferredWidth {
    NumberAnimation {
      duration: 250
      easing.type: Easing.OutCubic
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 12
    anchors.topMargin: 32
    spacing: 10
    clip: true

    CustomText{
      name: lang.settings.title
      Layout.alignment: Qt.AlignHCenter
      size: "normal"
      isBold: true
    }

    // Danh mục cài đặt
    Repeater {
      id: categoryRepeater
      model: [
      {
        name: lang.settings.general,
        icon: "settings/home.png",
        category: "general"
      },
      {
        name: lang.settings.appearance,
        icon: "settings/paint-brush.png",
        category: "appearance"
      },
      {
        name: lang.settings.network,
        icon: "settings/network.png",
        category: "network"
      },
      {
        name: lang.settings.audio,
        icon: "settings/volume.png",
        category: "audio"
      },
      {
        name: lang.settings.performance,
        icon: "settings/speedometer.png",
        category: "performance"
      },
      {
        name: lang.settings.shortcuts,
        icon: "settings/keyboard.png",
        category: "shortcuts"
      },
      {
        name: lang.settings.system,
        icon: "settings/mark.png",
        category: "system"
      }
      ]

      delegate: Rectangle {
        id: categoryDelegate
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        radius: 8

        property bool hovered: false
        property bool selected: sidebarSettings.currentIndex === index

        color: mouseArea.containsMouse || selected ? theme.button.background_select : theme.button.background
        border.color: mouseArea.containsMouse || selected ? theme.button.border_select : theme.button.border
        border.width: 2

        // Hiệu ứng scale
        scale: mouseArea.containsMouse ? 0.98 : 1.0
        Behavior on scale {
          NumberAnimation {
            duration: 100
          }
        }

        // Hiệu ứng màu
        Behavior on color {
          ColorAnimation {
            duration: 200
          }
        }
        Behavior on border.color {
          ColorAnimation {
            duration: 100
          }
        }

        RowLayout {
          anchors.fill: parent
          anchors.margins:  8
          spacing: 12

          IconImage {
            path: modelData.icon
            Layout.alignment: Qt.AlignHCenter
            rotation: !mouseArea.containsMouse
            ? 0
            : index % 2 === 0
            ? 20
            : -20
            scale: mouseArea.containsMouse ? 1.05 : 1.0
            Behavior on rotation {
              NumberAnimation {
                duration: 500
                easing.type: Easing.OutCubic
              }
            }
            Behavior on scale {
              NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
              }
            }
          }

          CustomText {
            name: modelData.name
            size: "small"
            textColor: mouseArea.containsMouse || selected ? theme.primary.bright_foreground : theme.primary.foreground
            isBold: selected
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Behavior on color {
              ColorAnimation {
                duration: 200
              }
            }

          }

          // Indicator khi selected - chỉ hiển thị khi expanded
          Rectangle {
            Layout.preferredWidth: 4
            Layout.preferredHeight:  20
            radius: 2
            color: theme.normal.blue
            visible: selected

            // Hiệu ứng xuất hiện
            scale: selected ? 1.0 : 0.0
            Behavior on scale {
              NumberAnimation {
                duration: 300
                easing.type: Easing.OutBack
              }
            }
            Behavior on opacity {
              NumberAnimation {
                duration: 200
              }
            }
          }
        }

        MouseArea {
          id: mouseArea
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          propagateComposedEvents: true

          onClicked: {
            sidebarSettings.currentIndex = index;
            sidebarSettings.categoryChanged(index);
          }

          onEntered: {
            categoryDelegate.hovered = true;
          }

          onExited: {
            categoryDelegate.hovered = false;
          }
        }
      }
    }

    Item {
      Layout.fillHeight: true
    } // Spacer
  }
}
