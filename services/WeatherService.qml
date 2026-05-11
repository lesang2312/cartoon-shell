pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.commons

Singleton {
  id: root

  // Properties
  property string apiKey: Settings.weather.keyApi
  property string location: Settings.weather.location
  property string lang: Settings.general.lang || "vi"
  property string temperature: ""
  property string condition: ""
  property string icon: ""
  property string humidity: ""
  property string feelsLike: ""
  property string windSpeed: ""
  property string pressure: ""
  property string visibility: ""
  property string uvIndex: ""
  property var forecastDays: []
  property bool isLoading: false
  property string errorMessage: ""

  // Process lấy weather forecast
  Process {
    id: weatherProcess
    command: ["curl", "-s", ""]
    running: false

    stdout: StdioCollector {
      onStreamFinished: {
        root.isLoading = false
        if (text && text.length > 0) {
          try {
            const data = JSON.parse(text)
            if (data.error) {
              root.errorMessage = data.error.message
            } else {
              root.processWeatherData(data)
              root.errorMessage = ""
            }
          } catch (e) {
            console.error("Lỗi parse JSON:", e)
            root.errorMessage = "Không thể phân tích dữ liệu thời tiết"
            root.temperature = "Lỗi"
            root.condition = "Dữ liệu không hợp lệ"
          }
        } else if (root.apiKey === "") {
          root.errorMessage = "Vui lòng nhập API key"
          root.temperature = "No API"
          root.condition = "Chưa có API key"
        } else {
          root.temperature = "Lỗi"
          root.condition = "Không có dữ liệu"
          root.errorMessage = "Không thể tải dữ liệu thời tiết"
        }
      }
    }
  }

  function processWeatherData(data) {
    if (data.current) {
      root.temperature = `${Math.round(data.current.temp_c)}°C`
      root.condition = data.current.condition.text
      root.humidity = `${data.current.humidity}%`
      root.feelsLike = `${Math.round(data.current.feelslike_c)}°C`
      root.windSpeed = `${data.current.wind_kph} km/h`
      root.pressure = `${data.current.pressure_mb} mb`
      root.visibility = `${data.current.vis_km} km`
      root.uvIndex = data.current.uv.toString()
      root.icon = root.getWeatherIcon(data.current.condition.code, data.current.is_day)
    }

    // Process forecast data
    if (data.forecast && data.forecast.forecastday) {
      root.processWeatherForecastData(data)
    }
  }

  function processWeatherForecastData(data) {
    if (data.forecast && data.forecast.forecastday) {
      const forecast = []
      for (let i = 0; i < data.forecast.forecastday.length; i++) {
        const day = data.forecast.forecastday[i]
        forecast.push({
            date: day.date,
            dateText: root.formatDate(day.date),
            dayName: root.getDayName(day.date),
            maxTemp: Math.round(day.day.maxtemp_c),
            minTemp: Math.round(day.day.mintemp_c),
            condition: day.day.condition.text,
            icon: root.getWeatherIcon(day.day.condition.code, true),
            rainChance: day.day.daily_chance_of_rain
        })
      }
      root.forecastDays = forecast
    }
  }

  function formatDate(dateStr) {
    const date = new Date(dateStr)
    return `${date.getDate()}/${date.getMonth() + 1}`
  }

  function getDayName(dateStr) {
    const date = new Date(dateStr)
    const today = new Date()
    const tomorrow = new Date(today)
    tomorrow.setDate(tomorrow.getDate() + 1)

    if (date.toDateString() === today.toDateString()) return "Hôm nay"
    if (date.toDateString() === tomorrow.toDateString()) return "Ngày mai"

    const days = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"]
    return days[date.getDay()]
  }

  function getWeatherIcon(code, isDay) {
    code = Number(code)

    const basePath = "weather/icon_weather_status"

    // ☀️ Clear / Sunny
    if (code === 1000)
    return isDay ? `${basePath}/sun.png` : `${basePath}/night.png`

    // ⛅ Partly cloudy
    if (code === 1003)
    return isDay ? `${basePath}/cloudy_sunny.png` : `${basePath}/cloudy_night.png`

    // ☁️ Cloudy / Overcast
    if ([1006, 1009].includes(code))
    return `${basePath}/cloudy.png`

    // 🌫️ Mist / Fog
    if ([1030].includes(code))
    return `${basePath}/mist.png`

    if ([1135, 1147].includes(code))
    return `${basePath}/fog.png`

    // 🌧️ Rain / Drizzle / Freezing rain
    if ((code >= 1063 && code <= 1195) || (code >= 1198 && code <= 1201))
    return `${basePath}/rain.png`

    // 🌨️ Snow / Sleet / Ice pellets
    if (code >= 1204 && code <= 1264)
    return `${basePath}/snowy.png`

    // ⛈️ Thunderstorm
    if (code >= 1273 && code <= 1282)
    return `${basePath}/thunder.png`

    // 🌈 Fallback
    return `${basePath}/rainbow.png`
  }

  function updateWeather() {
    if (root.apiKey === "" || root.apiKey === undefined) {
      root.errorMessage = "Vui lòng nhập API key"
      root.temperature = "No API"
      root.condition = "Chưa có key"
      root.isLoading = false
      return
    }

    if (!root.location || root.location === "") {
      root.errorMessage = "Vui lòng nhập địa điểm"
      root.isLoading = false
      return
    }

    root.isLoading = true
    root.errorMessage = ""

    const url = `https://api.weatherapi.com/v1/forecast.json?key=${root.apiKey}&q=${encodeURIComponent(root.location)}&days=3&lang=${root.lang}`
    weatherProcess.command = ["curl", "-s", url]
    weatherProcess.running = true
  }

  function saveApiKey(key) {
    if (key === "") {
      root.errorMessage = "Vui lòng nhập API key"
      return false
    }
    Settings.weather.keyApi = key
    root.apiKey = key
    root.updateWeather()
    return true
  }

  function saveLocation(loc) {
    if (loc === "") {
      root.errorMessage = "Vui lòng nhập địa điểm"
      return false
    }
    Settings.weather.location = loc
    root.location = loc
    root.updateWeather()
    return true
  }

  // Auto-update timer (every 30 minutes)
  Timer {
    interval: 1800000 // 30 minutes
    running: true
    repeat: true
    onTriggered: {
      if (root.apiKey !== "" && root.location !== "") {
        root.updateWeather()
      }
    }
  }

  // Initial load timer
  Timer {
    id: initialLoadTimer
    interval: 100
    running: true
    repeat: false
    onTriggered: {
      if (root.apiKey !== "" && root.location !== "") {
        root.updateWeather()
      } else if (root.apiKey === "") {
        root.temperature = "No API"
        root.condition = "Chưa có key"
      } else if (root.location === "") {
        root.temperature = "No Location"
        root.condition = "Chưa có địa điểm"
      }
    }
  }

  // Listen for settings changes
  Connections {
    target: Settings
    function onWeatherChanged() {
      if (Settings.weather.keyApi !== root.apiKey) {
        root.apiKey = Settings.weather.keyApi
      }
      if (Settings.weather.location !== root.location) {
        root.location = Settings.weather.location
      }
      if (root.apiKey !== "" && root.location !== "") {
        root.updateWeather()
      }
    }
  }

  Component.onCompleted: {
    // Initialize from settings
    root.apiKey = Settings.weather.keyApi
    root.location = Settings.weather.location
    root.lang = Settings.general.lang || "vi"
  }
}
