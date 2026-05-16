import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import "./flag/" as Com
import qs.commons

PanelWindow {
  id: flagSelectionPanel

  property var theme: ThemeService.theme

  property string selectedFlag: Settings.appearance.countryFlag
  property real animationProgress: 0
  SequentialAnimation on animationProgress {
    id: staggerAnimation
    running: true
    loops: 1

    PropertyAction { value: 0 }

    NumberAnimation { to: 0.2; duration: 50 }
  }

  implicitWidth: flagSelectionPanel.animationProgress > 0.1 ?  600 : 100
  implicitHeight: flagSelectionPanel.animationProgress > 0.1 ?  420 : 100
  Behavior on implicitHeight {
    NumberAnimation {
      duration: 60
      easing.type: Easing.OutCubic
    }
  }
  Behavior on implicitWidth {
    NumberAnimation {
      duration: 60
      easing.type: Easing.OutCubic
    }
  }

  property var flagList: [
  {
    name: "britain",
    displayName: "Britain"
  },
  {
    name: "bulgaria",
    displayName: "Bulgaria"
  },
  {
    name: "china",
    displayName: "China"
  },
  {
    name: "czech",
    displayName: "Czech"
  },
  {
    name: "denmark",
    displayName: "Denmark"
  },
  {
    name: "finland",
    displayName: "Finland"
  },
  {
    name: "france",
    displayName: "France"
  },
  {
    name: "german",
    displayName: "Germany"
  },
  {
    name: "greece",
    displayName: "Greece"
  },
  {
    name: "hungary",
    displayName: "Hungary"
  },
  {
    name: "india",
    displayName: "India"
  },
  {
    name: "indonesia",
    displayName: "Indonesia"
  },
  {
    name: "israel",
    displayName: "Israel"
  },
  {
    name: "italy",
    displayName: "Italy"
  },
  {
    name: "japan",
    displayName: "Japan"
  },
  {
    name: "korea",
    displayName: "Korea"
  },
  {
    name: "netherlands",
    displayName: "Netherlands"
  },
  {
    name: "norway",
    displayName: "Norway"
  },
  {
    name: "poland",
    displayName: "Poland"
  },
  {
    name: "portugal",
    displayName: "Portugal"
  },
  {
    name: "romania",
    displayName: "Romania"
  },
  {
    name: "russia",
    displayName: "Russia"
  },
  {
    name: "saudi_arabia",
    displayName: "Saudi Arabia"
  },
  {
    name: "slovakia",
    displayName: "Slovakia"
  },
  {
    name: "spain",
    displayName: "Spain"
  },
  {
    name: "sweden",
    displayName: "Sweden"
  },
  {
    name: "thailand",
    displayName: "Thailand"
  },
  {
    name: "turkey",
    displayName: "Turkey"
  },
  {
    name: "ukraine",
    displayName: "Ukraine"
  },
  {
    name: "vietnam",
    displayName: "Vietnam"
  }
  ]

  anchors {
    top: Settings.bar.position === "top"
    bottom: Settings.bar.position === "bottom"
    left: Settings.bar.position === "top" || Settings.bar.position === "bottom" || Settings.bar.position === "left"
    right: Settings.bar.position === "right"
  }

  margins {
    top: Settings.bar.position === "top" ? 10 : 0
    bottom: Settings.bar.position === "bottom" ? 10 : 0
    left: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? 720 : 10
    right: Settings.bar.position === "right" ? 10 : 0
  }

  exclusiveZone: 0
  color: "transparent"

  Rectangle {
    anchors.fill: parent
    color: theme.primary.background
    radius: 10
    border.color: theme.button.border
    border.width: 3

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 20
      spacing: 15

      // Header
      Com.FlagHeader{}

      // Flag Grid with Scroll
      ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOn

        Flow {
          height: 234
          width: parent.width
          spacing: 12
          flow: Flow.TopToBottom

          Repeater {
            model: flagSelectionPanel.flagList

            Rectangle {
              width: 105
              height: 70
              color: flagSelectionPanel.selectedFlag === modelData.name ? theme.primary.dim_background : theme.primary.background
              border.color: flagSelectionPanel.selectedFlag === modelData.name ? theme.normal.green : theme.button.border
              border.width: flagSelectionPanel.selectedFlag === modelData.name ? 3 : 2
              radius: 10

              Column {
                anchors.centerIn: parent
                spacing: 4

                Image {
                  source: `../../assets/flags/${modelData.name}.png`
                  width: 64
                  height: 45
                  fillMode: Image.PreserveAspectFit
                  smooth: true
                  anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                  text: modelData.displayName
                  color: theme.primary.foreground
                  font {
                    pixelSize: 12
                    family: "ComicShannsMono Nerd Font"
                    bold: flagSelectionPanel.selectedFlag === modelData.name
                  }
                  anchors.horizontalCenter: parent.horizontalCenter
                }
              }

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                  Settings.appearance.countryFlag = modelData.name;
                }

                onEntered: {
                  parent.scale = 1.05;
                }

                onExited: {
                  parent.scale = 1.0;
                }
              }

              Behavior on scale {
                NumberAnimation {
                  duration: 150
                }
              }
              Behavior on border.width {
                NumberAnimation {
                  duration: 150
                }
              }
            }
          }
        }
      }

      // Footer info
      Rectangle {
        Layout.fillWidth: true
        height: 1
        color: theme.normal.black
        opacity: 0.3
      }

      Text {
        text: `Selected: ${flagSelectionPanel.selectedFlag}`
        color: theme.primary.dim_foreground
        font {
          pixelSize: 16
          family: "ComicShannsMono Nerd Font"
          italic: true
        }
        Layout.alignment: Qt.AlignHCenter
      }
    }
  }
}
