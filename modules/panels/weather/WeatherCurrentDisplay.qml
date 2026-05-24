import QtQuick
import QtQuick.Layouts
import qs.services
import "." as Com
import qs.commons
import qs.components

RowLayout {
  id: root
  spacing: 20
  property real animationProgress: 0

  // Main weather card - LEFT
  Rectangle {
    visible: root.hasData
    Layout.preferredWidth: 200
    Layout.fillHeight: true
    radius: Settings.appearance.radius2
    border.width: Settings.appearance.enableBorder ? 2 : 0

    color: theme.primary.dim_background
    border.color: theme.primary.foreground
    opacity: root.animationProgress > 0.2 ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 20
      spacing: 12

      IconImage{
        path: WeatherService.icon
        size: "xl"
        Layout.alignment: Qt.AlignHCenter
        opacity: root.animationProgress > 0.5 ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }

      CustomText {
        name : WeatherService.temperature
        size: "2xl"
        isBold: true
        Layout.alignment: Qt.AlignHCenter
        opacity: root.animationProgress > 0.55 ? 1 : 0
      }

      CustomText {
        name : WeatherService.condition.slice(0, 15)
        size: "small"
        Layout.alignment: Qt.AlignHCenter
        opacity: root.animationProgress > 0.6 ? 1 : 0
      }

      Item {
        Layout.fillHeight: true
      }
    }
  }

  // Weather details grid - 3x2 layout - RIGHT
  GridLayout {
    visible: WeatherService.temperature !== "" && WeatherService.errorMessage === ""
    Layout.fillWidth: true
    Layout.fillHeight: true
    columns: 3
    columnSpacing: 5
    rowSpacing: 5

    // Humidity
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: "weather/humidity.png"
      value: WeatherService.humidity
      revealThreshold: 0.6
      animationProgress: root.animationProgress
      opacity: root.animationProgress > 0.3 ? 1 : 0
    }

    // Wind Speed
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: Settings.appearance.mode === "light" ? "weather/wind_light.png" : "weather/wind_dark.png"
      value: WeatherService.windSpeed
      revealThreshold: 0.65
      animationProgress: root.animationProgress
      opacity: root.animationProgress > 0.35 ? 1 : 0
    }

    // Pressure
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: "weather/pressure.png"
      value: WeatherService.pressure
      revealThreshold: 0.7
      animationProgress: root.animationProgress
      opacity: root.animationProgress > 0.4 ? 1 : 0
    }

    // Visibility
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: "weather/visibility.png"
      value: WeatherService.visibility
      revealThreshold: 0.75
      animationProgress: root.animationProgress
      opacity: root.animationProgress > 0.45 ? 1 : 0
    }

    // UV Index
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: Settings.appearance.mode === "light" ? "weather/uv_light.png" : "weather/uv_dark.png"
      value: WeatherService.uvIndex
      revealThreshold: 0.8
      animationProgress: root.animationProgress
      opacity: root.animationProgress > 0.5 ? 1 : 0
    }

    // Feels Like
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: Settings.appearance.mode === "light" ? "weather/feels_like_light.png" : "weather/feels_like_dark.png"
      value: WeatherService.feelsLike
      revealThreshold: 0.85
      animationProgress: root.animationProgress
      opacity: root.animationProgress > 0.55 ? 1 : 0
    }
  }
}
