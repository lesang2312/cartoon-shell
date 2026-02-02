import QtQuick
import Quickshell
import Quickshell.Io
import qs.commons

Item {
    id: root

    property string apiKey: Settings.weather.keyApi
    property string location: Settings.weather.location
    property string lang: "vi"
    property string temperature: "..."
    property string condition: "Đang tải"
    property string icon: ""
    property string humidity: ""
    property string feelsLike: ""

    Process {
        id: weatherProcess
        command: ["curl", "-s", `https://api.weatherapi.com/v1/current.json?key=${root.apiKey}&q=${root.location.replace(/ /g, '%20')}&lang=${root.lang}`]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                if (text && text.length > 0 && root.apiKey !== "") {
                    try {
                        const parsed = JSON.parse(text);
                        root.processWeatherData(parsed);
                    } catch (e) {
                        console.error("Lỗi parse JSON:", e);
                        root.temperature = "Lỗi";
                        root.condition = "Dữ liệu không hợp lệ";
                    }
                } else if (root.apiKey === "") {
                    root.temperature = "No API";
                    root.condition = "Chưa có API key";
                } else {
                    root.temperature = "Lỗi";
                    root.condition = "Không có dữ liệu";
                }
            }
        }
    }

    function processWeatherData(data) {
        if (data.current) {
            root.temperature = `${Math.round(data.current.temp_c)}°C`;
            root.condition = data.current.condition.text;
            root.humidity = `${data.current.humidity}%`;
            root.feelsLike = `${Math.round(data.current.feelslike_c)}°C`;
            root.icon = root.getWeatherIcon(data.current.condition.code, data.current.is_day);
        }
    }

    function getWeatherIcon(code, isDay) {
        code = Number(code);

        const basePath = Directories.assetsPath + "/weather/icon_weather_status";

        // ☀️ Clear / Sunny
        if (code === 1000)
            return isDay ? `${basePath}/sun.png` : `${basePath}/night.png`;

        // ⛅ Partly cloudy
        if (code === 1003)
            return isDay ? `${basePath}/cloudy_sunny.png` : `${basePath}/cloudy_night.png`;

        // ☁️ Cloudy / Overcast
        if ([1006, 1009].includes(code))
            return `${basePath}/cloudy.png`;

        // 🌫️ Mist / Fog
        if ([1030].includes(code))
            return `${basePath}/mist.png`;

        if ([1135, 1147].includes(code))
            return `${basePath}/fog.png`;

        // 🌧️ Rain / Drizzle / Freezing rain
        if ((code >= 1063 && code <= 1195) || (code >= 1198 && code <= 1201))
            return `${basePath}/rain.png`;

        // 🌨️ Snow / Sleet / Ice pellets
        if (code >= 1204 && code <= 1264)
            return `${basePath}/snowy.png`;

        // ⛈️ Thunderstorm
        if (code >= 1273 && code <= 1282)
            return `${basePath}/thunder.png`;

        // 🌈 Fallback
        return `${basePath}/rainbow.png`;
    }

    function updateWeather() {
        if (root.apiKey === "" || root.apiKey === undefined) {
            root.temperature = "No API";
            root.condition = "Chưa có key";
            return;
        }
        if (!weatherProcess.running) {
            weatherProcess.running = true;
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: root.updateWeather()
    }

    Timer {
        id: initialLoadTimer
        interval: 100
        running: true
        repeat: false
        onTriggered: root.updateWeather()
    }
}
