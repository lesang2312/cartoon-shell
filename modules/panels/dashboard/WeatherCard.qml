import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Io
import qs.services
import qs.components

Rectangle {
  id: root
  property var theme : ThemeService.theme

  Layout.preferredWidth: 400
  Layout.preferredHeight: 240
  radius: 28
  color: theme.primary.background
  border.width: 3
  border.color: theme.button.border
  clip: true

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 20
    spacing: 12

    // Current weather display
    RowLayout {
      Layout.fillWidth: true
      spacing: 15
      Layout.alignment: Qt.AlignHCenter

      IconImage {
        path: WeatherService.icon
        size: "3xl"
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 5

        CustomText {
          name: WeatherService.temperature || "Đang tải..."
          Layout.alignment: Qt.AlignVCenter
          size: "2xl"
          isBold: true
        }
        CustomText {
          id: textCondition

          name: WeatherService.condition.slice(0, 15) || "..."
          size: "large"
          elide: Text.ElideRight
          maximumLineCount: 1
        }

      }
    }

    // Forecast row - horizontal layout
    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: 8

      Repeater {
        model: WeatherService.forecastDays

        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          radius: 12
          color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
          border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
          border.width: 1

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 4

            // Day name
            Text {
              text: modelData.dayName
              color: theme.primary.foreground
              font {
                pixelSize: 16
                bold: index === 0
                family: "ComicShannsMono Nerd Font"
              }
              Layout.alignment: Qt.AlignHCenter
              elide: Text.ElideRight
            }

            // Weather icon
            IconImage{
              path: modelData.icon
              size: "normal"
              Layout.alignment: Qt.AlignHCenter
            }

            // Temperature range
            RowLayout {
              Layout.alignment: Qt.AlignHCenter
              spacing: 2

              Text {
                text: `${modelData.minTemp}°`
                color: theme.normal.cyan
                font {
                  pixelSize: 16
                  bold: true
                  family: "ComicShannsMono Nerd Font"
                }
              }

              Text {
                text: "/"
                color: theme.primary.dim_foreground
                font.pixelSize: 16
              }

              Text {
                text: `${modelData.maxTemp}°`
                color: theme.normal.red
                font {
                  pixelSize: 16
                  family: "ComicShannsMono Nerd Font"
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
