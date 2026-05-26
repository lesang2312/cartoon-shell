import QtQuick
import QtQuick.Layouts
import qs.services
import "." as Com

Item {

  id: root
  visible: WeatherService.forecastDays.length > 0
  Layout.fillWidth: true
  Layout.preferredHeight: 200
  property real animationProgress: 0

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
        animationProgress: weatherPanel.animationProgress
        revealThreshold: 0.9
        opacity: root.animationProgress > 0.6 ? 1 : 0
      }
      Item {Layout.fillWidth: true}
      Com.WeatherForecastItem {
        dayName: WeatherService.forecastDays[1]?.dayName ?? ""
        dateText: WeatherService.forecastDays[1]?.dateText ?? ""
        icon: WeatherService.forecastDays[1]?.icon ?? ""
        minTemp: (WeatherService.forecastDays[1]?.minTemp ?? "") + "℃ "
        maxTemp: (WeatherService.forecastDays[1]?.maxTemp ?? "") + "℃ "
        animationProgress: weatherPanel.animationProgress
        revealThreshold: 1
        opacity: root.animationProgress > 0.7 ? 1 : 0
      }

      Item {Layout.fillWidth: true}

      Com.WeatherForecastItem {
        dayName: WeatherService.forecastDays[2]?.dayName ?? ""
        dateText: WeatherService.forecastDays[2]?.dateText ?? ""
        icon: WeatherService.forecastDays[2]?.icon ?? ""
        minTemp: (WeatherService.forecastDays[2]?.minTemp ?? "") + "℃ "
        maxTemp: (WeatherService.forecastDays[2]?.maxTemp ?? "") + "℃ "
        animationProgress: weatherPanel.animationProgress
        revealThreshold: 1.1
        opacity: root.animationProgress > 0.8 ? 1 : 0
      }
    }
  }
}
