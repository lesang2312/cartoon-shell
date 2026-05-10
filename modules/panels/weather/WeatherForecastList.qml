import QtQuick
import QtQuick.Layouts
import qs.services
import "." as Com

Rectangle {
  id: forecastSection

  property var theme: ThemeService.theme
  required property var forecastDays

  visible: forecastDays.length > 0
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
        dayName: forecastSection.forecastDays[0]?.dayName ?? ""
        dateText: forecastSection.forecastDays[0]?.dateText ?? ""
        icon: forecastSection.forecastDays[0]?.icon ?? ""
        minTemp: (forecastSection.forecastDays[0]?.minTemp ?? "") + "℃ "
        maxTemp: (forecastSection.forecastDays[0]?.maxTemp ?? "") + "℃ "
      }
      Item {Layout.fillWidth: true}
      Com.WeatherForecastItem {
        dayName: forecastSection.forecastDays[1]?.dayName ?? ""
        dateText: forecastSection.forecastDays[1]?.dateText ?? ""
        icon: forecastSection.forecastDays[1]?.icon ?? ""
        minTemp: (forecastSection.forecastDays[1]?.minTemp ?? "") + "℃ "
        maxTemp: (forecastSection.forecastDays[1]?.maxTemp ?? "") + "℃ "
      }

      Item {Layout.fillWidth: true}

      Com.WeatherForecastItem {
        dayName: forecastSection.forecastDays[2]?.dayName ?? ""
        dateText: forecastSection.forecastDays[2]?.dateText ?? ""
        icon: forecastSection.forecastDays[2]?.icon ?? ""
        minTemp: (forecastSection.forecastDays[2]?.minTemp ?? "") + "℃ "
        maxTemp: (forecastSection.forecastDays[2]?.maxTemp ?? "") + "℃ "
      }
    }
  }
}
