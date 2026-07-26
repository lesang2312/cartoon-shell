import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
import qs.commons

ColumnLayout {
  id: root
  property real animationProgress: 0
  spacing: ScalerService.s(15)

  // Header với title và description
  RowLayout {
    Layout.fillWidth: true
    spacing: ScalerService.s(10)

    CustomText {
      name: "Icon Workspace"
      isBold: true
      Layout.fillWidth: true
    }
  }

  // Grid hiển thị các icon
  GridLayout {
    Layout.fillWidth: true
    columns: Math.min(8, Math.floor(root.width / ScalerService.s(50)))
    rowSpacing: ScalerService.s(8)
    columnSpacing: ScalerService.s(8)

    Repeater {
      model: [
      {
        name: "pacman",
        style: "image"
      },
      {
        name: "luffy",
        style: "image"
      },
      {
        name: "zoro",
        style: "image"
      },
      {
        name: "nami",
        style: "image"
      },
      {
        name: "usopp",
        style: "image"
      },
      {
        name: "sanji",
        style: "image"
      },
      {
        name: "chopper",
        style: "image"
      },
      {
        name: "goku",
        style: "image"
      },
      {
        name: "karin",
        style: "image"
      },
      {
        name: "circle",
        style: "icon"
      }
      ]

      delegate: Item {
        id: delegateItem
        Layout.fillWidth: true
        Layout.preferredHeight: width
        Rectangle {
          id: container
          implicitWidth: 0
          anchors.centerIn: delegateItem
          implicitHeight: 0
          SequentialAnimation on implicitWidth {
            running: root.animationProgress > 0.2

            PauseAnimation {
              duration: index * 15
            }

            NumberAnimation {
              to: delegateItem.width
              duration: 500
              easing.type: Easing.OutCubic
            }
          }
          SequentialAnimation on implicitHeight {
            running: root.animationProgress > 0.2

            PauseAnimation {
              duration: index * 15
            }

            NumberAnimation {
              to: delegateItem.height
              duration: 500
              easing.type: Easing.OutCubic
            }
          }
          anchors.margins: ScalerService.s(2)
          radius: ScalerService.s(12)

          color: {
            if (Settings.bar.iconWorkspace === modelData.name) {
              return Qt.alpha(theme.button.text, 0.15);
            }
            return mouseArea.containsMouse ? Qt.alpha(theme.button.background_select, 0.4) : Qt.alpha(theme.button.background, 0.2);
          }

          border.color: {
            if (Settings.bar.iconWorkspace === modelData.name) {
              return Qt.alpha(theme.button.text, 0.8);
            }
            return mouseArea.containsPress ? Qt.alpha(theme.button.border_select, 0.6) : Qt.alpha(theme.button.border, 0.3);
          }
          border.width: ScalerService.s(2)

          // Animation cho border và background
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
          Behavior on border.color {
            ColorAnimation {
              duration: 200
            }
          }

          // Icon image
          IconImage {
            id: iconImage
            visible: modelData.style === "image"
            anchors.centerIn: parent
            path: `workspace/${modelData.name}/active.png`
          }
          IconText {
            visible: modelData.style === "icon"
            name: modelData.name
            textColor: theme.button.text
            anchors.centerIn: parent
          }

          // Mouse area
          MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
              SoundService.playSound("pick");
              if (modelData.style === "image") {
                Settings.bar.styleWorkspace = "image";
                Settings.bar.iconWorkspace = modelData.name;
              } else if (modelData.style === "icon") {
                Settings.bar.styleWorkspace = "icon";
                Settings.bar.iconWorkspace = modelData.name;
              }
            }
          }
        }
      }
    }
  }
}
