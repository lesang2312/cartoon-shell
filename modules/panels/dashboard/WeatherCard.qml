import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Io
import qs.services
import qs.components
import qs.commons

Rectangle {
  id: root
  property real animationProgress: 0

  Layout.preferredWidth: ScalerService.s(400)
  Layout.preferredHeight: ScalerService.s(240)

  radius: ScalerService.s(Settings.appearance.radius1)
  border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
  border.color: theme.button.border
  color: theme.primary.background
  clip: true
  Behavior on opacity {
    NumberAnimation {
      duration: 200
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: ScalerService.s(20)
    spacing: ScalerService.s(12)

    // Current weather display
    RowLayout {
      Layout.fillWidth: true
      spacing: ScalerService.s(15)
      Layout.alignment: Qt.AlignHCenter

      IconImage {
        path: WeatherService.icon
        size: "3xl"
        opacity: root.animationProgress > 0.75 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: ScalerService.s(5)

        CustomText {
          name: WeatherService.temperature || "Đang tải..."
          Layout.alignment: Qt.AlignVCenter
          size: "2xl"
          isBold: true
          opacity: root.animationProgress > 0.77 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
        CustomText {
          id: textCondition

          name: WeatherService.condition.slice(0, 15) || "..."
          size: "large"
          elide: Text.ElideRight
          maximumLineCount: 1
          opacity: root.animationProgress > 0.8 ? 1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }

      }
    }

    // Forecast row - horizontal layout
    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: ScalerService.s(8)

      Repeater {
        model: WeatherService.forecastDays

        Item {
          Layout.fillWidth: true
          Layout.fillHeight: true

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: ScalerService.s(8)
            spacing: ScalerService.s(4)

            // Day name
            CustomText{
              name: modelData.dayName
              isBold: true
              size: "small"
              Layout.alignment: Qt.AlignHCenter
              elide: Text.ElideRight
              opacity: 0
              SequentialAnimation on opacity {
                running: root.animationProgress > 0.85

                PauseAnimation {
                  duration: index * 50
                }

                NumberAnimation {
                  to: 1
                  duration: 200
                  easing.type: Easing.OutCubic
                }
              }
            }

            // Weather icon
            IconImage{
              path: modelData.icon
              size: "normal"
              Layout.alignment: Qt.AlignHCenter
              opacity: 0
              SequentialAnimation on opacity {
                running: root.animationProgress > 0.85

                PauseAnimation {
                  duration: index * 30
                }

                NumberAnimation {
                  to: 1
                  duration: 200
                  easing.type: Easing.OutCubic
                }
              }
            }

            // Temperature range
            RowLayout {
              Layout.alignment: Qt.AlignHCenter
              spacing: ScalerService.s(2)

              CustomText {
                name: `${modelData.minTemp}°`
                textColor: theme.normal.cyan

                size: "small"
                isBold: true
                opacity: 0
                SequentialAnimation on opacity {
                  running: root.animationProgress > 0.85

                  PauseAnimation {
                    duration: index * 20
                  }

                  NumberAnimation {
                    to: 1
                    duration: 200
                    easing.type: Easing.OutCubic
                  }
                }
              }

              CustomText {
                name: "/"
                textColor: theme.primary.dim_foreground
                size: "small"
                isBold: true
                opacity: 0
                SequentialAnimation on opacity {
                  running: root.animationProgress > 0.85

                  PauseAnimation {
                    duration: index * 40
                  }

                  NumberAnimation {
                    to: 1
                    duration: 200
                    easing.type: Easing.OutCubic
                  }
                }
              }

              CustomText {
                name: `${modelData.maxTemp}°`
                textColor: theme.normal.red

                size: "small"
                isBold: true
                opacity: 0
                SequentialAnimation on opacity {
                  running: root.animationProgress > 0.85

                  PauseAnimation {
                    duration: index * 60
                  }

                  NumberAnimation {
                    to: 1
                    duration: 200
                    easing.type: Easing.OutCubic
                  }
                }
              }
            }

            Item { Layout.fillHeight: true }
          }
        }
      }
    }
  }
}
