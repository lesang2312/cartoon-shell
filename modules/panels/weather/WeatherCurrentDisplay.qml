import QtQuick
import QtQuick.Layouts
import qs.services
import "." as Com
import qs.commons
import qs.components

RowLayout {
  id: currentDisplay
  spacing: 20

  // Main weather card - LEFT
  Rectangle {
    visible: currentDisplay.hasData
    Layout.preferredWidth: 200
    Layout.fillHeight: true
    radius: 16

    color: theme.primary.dim_background
    border.color: theme.primary.foreground
    border.width: 1

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 20
      spacing: 12

      IconImage{
        path: WeatherService.icon
        size: "xl"
        Layout.alignment: Qt.AlignHCenter

      }

      CustomText {
        name : WeatherService.temperature
        size: "2xl"
        isBold: true
        Layout.alignment: Qt.AlignHCenter
      }

      CustomText {
        name : WeatherService.condition.slice(0, 15)
        size: "small"
        Layout.alignment: Qt.AlignHCenter
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
    }

    // Wind Speed
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: Settings.appearance.mode === "light" ? "weather/wind_light.png" : "weather/wind_dark.png"
      value: WeatherService.windSpeed
    }

    // Pressure
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: "weather/pressure.png"
      value: WeatherService.pressure
    }

    // Visibility
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: "weather/visibility.png"
      value: WeatherService.visibility
    }

    // UV Index
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: Settings.appearance.mode === "light" ? "weather/uv_light.png" : "weather/uv_dark.png"
      value: WeatherService.uvIndex
    }

    // Feels Like
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: Settings.appearance.mode === "light" ? "weather/feels_like_light.png" : "weather/feels_like_dark.png"
      value: WeatherService.feelsLike
    }
  }
}
