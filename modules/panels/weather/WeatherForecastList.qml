import QtQuick
import QtQuick.Layouts
import qs.services
import "." as Com

Rectangle {

  property var theme: ThemeService.theme

  visible: WeatherService.forecastDays.length > 0
  Layout.fillWidth: true
  Layout.preferredHeight: 200
  radius: 16
  color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
  border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
  border.width: 1

  ColumnLayout {
    anchors.fill: parent
    spacing: 12

    // Forecast row - horizontal layout
    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true

      Com.WeatherForecastItem {
        dayName: WeatherService.forecastDays[0]?.dayName ?? ""
        dateText: WeatherService.forecastDays[0]?.dateText ?? ""
        icon: WeatherService.forecastDays[0]?.icon ?? ""
        minTemp: (WeatherService.forecastDays[0]?.minTemp ?? "") + "℃ "
        maxTemp: (WeatherService.forecastDays[0]?.maxTemp ?? "") + "℃ "
      }
      Item {Layout.fillWidth: true}
      Com.WeatherForecastItem {
        dayName: WeatherService.forecastDays[1]?.dayName ?? ""
        dateText: WeatherService.forecastDays[1]?.dateText ?? ""
        icon: WeatherService.forecastDays[1]?.icon ?? ""
        minTemp: (WeatherService.forecastDays[1]?.minTemp ?? "") + "℃ "
        maxTemp: (WeatherService.forecastDays[1]?.maxTemp ?? "") + "℃ "
      }

      Item {Layout.fillWidth: true}

      Com.WeatherForecastItem {
        dayName: WeatherService.forecastDays[2]?.dayName ?? ""
        dateText: WeatherService.forecastDays[2]?.dateText ?? ""
        icon: WeatherService.forecastDays[2]?.icon ?? ""
        minTemp: (WeatherService.forecastDays[2]?.minTemp ?? "") + "℃ "
        maxTemp: (WeatherService.forecastDays[2]?.maxTemp ?? "") + "℃ "
      }
    }
  }
}
