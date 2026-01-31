import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import qs.commons
import "." as Com

PanelWindow {
    id: weatherPanel

    property var theme : ThemeService.theme
    property var lang : LanguageService.translations


    implicitWidth: 1000
    implicitHeight: 550
    focusable: true

    property string apiKey: Settings.weather.keyApi
    property string location: Settings.weather.location
    property string temperature: ""
    property string condition: ""
    property string icon: "⛅"
    property string humidity: ""
    property string feelsLike: ""
    property string windSpeed: ""
    property string pressure: ""
    property string visibility: ""
    property string uvIndex: ""
    property var forecastDays: []
    property bool isLoading: false
    property string errorMessage: ""
    property bool isSearchingLocation: false
    property var locationSearchResults: []
    property int currentLocationIndex: 0
    property bool isUserSearching: false

    // Timer auto-validate API key
    property Timer apiKeyValidateTimer: Timer {
        interval: 500
        repeat: false
        onTriggered: {
            if (weatherPanel.apiKey !== Settings.weather.keyApi) {
                saveAndValidateApiKey(weatherPanel.apiKey)
            }
        }
    }

    // Timer debounce location search
    property Timer searchDebounceTimer: Timer {
        interval: 300
        repeat: false
        onTriggered: {
            if (weatherPanel.location.length >= 2 && weatherPanel.isUserSearching) {
                searchLocation(weatherPanel.location)
            }
        }
    }

    // Timer ẩn location results
    Timer {
        id: hideResultsTimer
        interval: 200
        repeat: false
        onTriggered: {
            weatherPanel.locationSearchResults = []
            weatherPanel.isUserSearching = false
        }
    }

    anchors {
        top: Settings.bar.position === "top"
        bottom: Settings.bar.position === "bottom"
        left: Settings.bar.position === "top" || Settings.bar.position === "bottom" || Settings.bar.position === "left"
        right: Settings.bar.position === "right"
    }

    margins {
        top: Settings.bar.position === "top" ? 10 : 0
        bottom: Settings.bar.position === "bottom" ? 10 : 0
        left: (Settings.bar.position === "top" || Settings.bar.position === "bottom") ? 400 : 10
        right: Settings.bar.position === "right" ? 10 : 0
    }

    exclusiveZone: 0
    color: "transparent"

    // Process tìm kiếm địa điểm
    Process {
        id: searchLocationProcess
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                weatherPanel.isSearchingLocation = false
                weatherPanel.locationSearchResults = []
                if (text && text.length > 0) {
                    try {
                        const data = JSON.parse(text)
                        if (!data.error) {
                            weatherPanel.locationSearchResults = data
                            if (data.length > 0) {
                                weatherPanel.currentLocationIndex = 0
                            }
                        }
                    } catch(e) {}
                }
            }
        }
    }

    // Process lấy weather forecast
    Process {
        id: weatherProcess
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                weatherPanel.isLoading = false
                if (text && text.length > 0) {
                    try {
                        const data = JSON.parse(text)
                        if (data.error) {
                            weatherPanel.errorMessage = data.error.message
                        } else {
                            weatherPanel.processWeatherData(data)
                            weatherPanel.errorMessage = ""
                        }
                    } catch(e) {
                        weatherPanel.errorMessage = "Không thể phân tích dữ liệu thời tiết"
                    }
                } else if (weatherPanel.apiKey === "") {
                    weatherPanel.errorMessage = "Vui lòng nhập API key"
                }
            }
        }
    }

    function processWeatherData(data) {
        if (data.current) {
            temperature = `${Math.round(data.current.temp_c)}°C`
            condition = data.current.condition.text
            humidity = `${data.current.humidity}%`
            feelsLike = `${Math.round(data.current.feelslike_c)}°C`
            windSpeed = `${data.current.wind_kph} km/h`
            pressure = `${data.current.pressure_mb} mb`
            visibility = `${data.current.vis_km} km`
            uvIndex = data.current.uv.toString()
            icon = getWeatherIcon(data.current.condition.code, data.current.is_day,theme)
        }

        if (data.forecast && data.forecast.forecastday) {
            const forecast = []
            for (let i = 0; i < data.forecast.forecastday.length; i++) {
                const day = data.forecast.forecastday[i]
                forecast.push({
                    date: day.date,
                    dateText: formatDate(day.date),
                    dayName: getDayName(day.date),
                    maxTemp: Math.round(day.day.maxtemp_c),
                    minTemp: Math.round(day.day.mintemp_c),
                    condition: day.day.condition.text,
                    icon: getWeatherIcon(day.day.condition.code, true),
                    rainChance: day.day.daily_chance_of_rain
                })
            }
            forecastDays = forecast
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

        if (date.toDateString() === today.toDateString()) return lang?.dateFormat?.today || "Hôm nay"
        if (date.toDateString() === tomorrow.toDateString()) return lang?.dateFormat?.tomorrow || "Ngày mai"

        const weekdays = lang?.dateFormat?.day
        const days = weekdays ? [
            weekdays.sunday || "CN", weekdays.monday || "T2", weekdays.tuesday || "T3",
            weekdays.wednesday || "T4", weekdays.thursday || "T5",
            weekdays.friday || "T6", weekdays.saturday || "T7"
        ] : ["CN", "T2", "T3", "T4", "T5", "T6", "T7"]
        return days[date.getDay()]
    }

      function getWeatherIcon(code, isDay) {
    code = Number(code)

    const basePath = "../../../assets/weather/icon_weather_status"

    // ☀️ Clear / Sunny
    if (code === 1000)
        return isDay
            ? `${basePath}/sun.png`
            : `${basePath}/night.png`

    // ⛅ Partly cloudy
    if (code === 1003)
        return isDay
            ? `${basePath}/cloudy_sunny.png`
            : `${basePath}/cloudy_night.png`

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


    function saveAndValidateApiKey(key) {
        if (key === "") {
            errorMessage = "Vui lòng nhập API key"
            return
        }
        Settings.weather.keyApi = key
        weatherPanel.apiKey = key
        updateWeather()
    }

    function searchLocation(query) {
        if (query === "" || apiKey === "") {
            locationSearchResults = []
            isSearchingLocation = false
            return
        }
        try { searchLocationProcess.running = false } catch(e) {}
        isSearchingLocation = true
        const url = `https://api.weatherapi.com/v1/search.json?key=${apiKey}&q=${encodeURIComponent(query)}`
        searchLocationProcess.command = ["curl", "-s", url]
        searchLocationProcess.running = true
    }

    function selectLocation(locationName) {
        Settings.weather.location = locationName
        location = locationName
        locationSearchResults = []
        currentLocationIndex = 0
        isUserSearching = false
        updateWeather()
    }

    function updateWeather() {
        if (apiKey === "") {
            errorMessage = "Vui lòng nhập API key"
            return
        }
        isLoading = true
        errorMessage = ""
        const url = `https://api.weatherapi.com/v1/forecast.json?key=${apiKey}&q=${encodeURIComponent(location)}&days=3&lang=${Settings.general.lang}`
        weatherProcess.command = ["curl", "-s", url]
        weatherProcess.running = true
    }

    // Main UI
    Rectangle {
        anchors.fill: parent
        radius: 20
        border.color: theme.button.border
        border.width: 3

        color: theme.primary.background

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            // Header
            Com.WeatherHeader {}

            // Main content - 2 columns
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 20

                // Left: Config
                Com.WeatherConfigSection {
                    apiKey: weatherPanel.apiKey
                    location: weatherPanel.location
                    isSearchingLocation: weatherPanel.isSearchingLocation
                    locationSearchResults: weatherPanel.locationSearchResults
                    currentLocationIndex: weatherPanel.currentLocationIndex
                    isUserSearching: weatherPanel.isUserSearching
                    errorMessage: weatherPanel.errorMessage

                    onApiKeyEdited: function(newKey) {
                        weatherPanel.apiKey = newKey
                        weatherPanel.apiKeyValidateTimer.restart()
                    }

                    onLocationTextEdited: function(newText) {
                        weatherPanel.location = newText
                        weatherPanel.searchDebounceTimer.stop()
                        if (newText.length >= 2) {
                            weatherPanel.searchDebounceTimer.restart()
                        } else {
                            weatherPanel.locationSearchResults = []
                            weatherPanel.currentLocationIndex = 0
                        }
                    }

                    onLocationFocusStatusChanged: function(hasFocus) {
                        if (hasFocus) {
                            weatherPanel.isUserSearching = true
                        } else {
                            hideResultsTimer.restart()
                        }
                    }

                    onSearchLocationRequested: function(query) {
                        weatherPanel.searchLocation(query)
                    }

                    onLocationSelected: function(locationName) {
                        weatherPanel.selectLocation(locationName)
                    }
                }

                // Right: Weather Display
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.6
                    radius: 16
                    color: theme.primary.background

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 1
                        spacing: 20

                        // Current weather
                        Com.WeatherCurrentDisplay {
                            Layout.fillWidth: true
                            Layout.preferredHeight: parent.height/2
                            temperature: weatherPanel.temperature
                            condition: weatherPanel.condition
                            icon: weatherPanel.icon
                            feelsLike: weatherPanel.feelsLike
                            humidity: weatherPanel.humidity
                            windSpeed: weatherPanel.windSpeed
                            pressure: weatherPanel.pressure
                            visibility: weatherPanel.visibility
                            uvIndex: weatherPanel.uvIndex
                            hasData: weatherPanel.temperature !== "" && weatherPanel.errorMessage === ""
                        }

                        // 7-day forecast
                        Com.WeatherForecastList {
                            Layout.preferredHeight: parent.height/2
                            theme: weatherPanel.theme
                            forecastDays: weatherPanel.forecastDays
                        }
                    }
                }
            }
        }
    }

    // Keyboard shortcuts
    Shortcut {
        sequence: "Up"
        enabled: locationSearchResults.length > 0
        onActivated: {
            if (currentLocationIndex > 0) currentLocationIndex--
            else currentLocationIndex = locationSearchResults.length - 1
        }
    }

    Shortcut {
        sequence: "Down"
        enabled: locationSearchResults.length > 0
        onActivated: {
            if (currentLocationIndex < locationSearchResults.length - 1) currentLocationIndex++
            else currentLocationIndex = 0
        }
    }

    Shortcut {
        sequence: "Return"
        enabled: locationSearchResults.length > 0
        onActivated: {
            var item = locationSearchResults[currentLocationIndex]
            if (item) selectLocation(`${item.name},${item.country}`)
        }
    }
        Component.onCompleted: {
        if (apiKey && location) {
            updateWeather()
        }
    }
}
