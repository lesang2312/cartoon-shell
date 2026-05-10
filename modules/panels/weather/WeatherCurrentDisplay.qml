import QtQuick
import QtQuick.Layouts
import qs.services
import "." as Com
import qs.commons
import qs.components

RowLayout {
  id: currentDisplay

  required property string temperature
  required property string condition
  required property string icon
  required property string feelsLike
  required property string humidity
  required property string windSpeed
  required property string pressure
  required property string visibility
  required property string uvIndex
  required property bool hasData

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
        path: currentDisplay.icon
        size: "xl"
        Layout.alignment: Qt.AlignHCenter

      }

      CustomText {
        name : currentDisplay.temperature
        size: "2xl"
        isBold: true
        Layout.alignment: Qt.AlignHCenter
      }

      CustomText {
        name : currentDisplay.condition.slice(0, 15)
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
    visible: currentDisplay.hasData
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
      value: currentDisplay.humidity
    }

    // Wind Speed
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: Settings.appearance.mode === "light" ? "weather/wind_light.png" : "weather/wind_dark.png"
      value: currentDisplay.windSpeed
    }

    // Pressure
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: "weather/pressure.png"
      value: currentDisplay.pressure
    }

    // Visibility
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: "weather/visibility.png"
      value: currentDisplay.visibility
    }

    // UV Index
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: Settings.appearance.mode === "light" ? "weather/uv_light.png" : "weather/uv_dark.png"
      value: currentDisplay.uvIndex
    }

    // Feels Like
    Com.WeatherDetailCard {
      Layout.fillWidth: true
      Layout.fillHeight: true
      image: Settings.appearance.mode === "light" ? "weather/feels_like_light.png" : "weather/feels_like_dark.png"
      value: currentDisplay.feelsLike
    }
  }
}
