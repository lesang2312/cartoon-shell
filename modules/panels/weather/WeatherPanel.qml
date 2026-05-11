import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.services
import qs.commons
import "." as Com

PanelWindow {
  id: weatherPanel

  property var theme: ThemeService.theme
  property var lang: LanguageService.translations

  implicitWidth: 1000
  implicitHeight: 550
  focusable: true

  property string apiKey: Settings.weather.keyApi
  property string location: Settings.weather.location
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
        saveAndValidateApiKey(weatherPanel.apiKey);
      }
    }
  }

  // Timer debounce location search
  property Timer searchDebounceTimer: Timer {
    interval: 300
    repeat: false
    onTriggered: {
      if (weatherPanel.location.length >= 2 && weatherPanel.isUserSearching) {
        searchLocation(weatherPanel.location);
      }
    }
  }

  // Timer ẩn location results
  Timer {
    id: hideResultsTimer
    interval: 200
    repeat: false
    onTriggered: {
      weatherPanel.locationSearchResults = [];
      weatherPanel.isUserSearching = false;
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
        weatherPanel.isSearchingLocation = false;
        weatherPanel.locationSearchResults = [];
        if (text && text.length > 0) {
          try {
            const data = JSON.parse(text);
            if (!data.error) {
              weatherPanel.locationSearchResults = data;
              if (data.length > 0) {
                weatherPanel.currentLocationIndex = 0;
              }
            }
          } catch (e) {}
        }
      }
    }
  }

  function saveAndValidateApiKey(key) {
    if (key === "") {
      errorMessage = "Vui lòng nhập API key";
      return;
    }
    Settings.weather.keyApi = key;
    weatherPanel.apiKey = key;
    updateWeather();
  }

  function searchLocation(query) {
    if (query === "" || apiKey === "") {
      locationSearchResults = [];
      isSearchingLocation = false;
      return;
    }
    try {
      searchLocationProcess.running = false;
    } catch (e) {}
    isSearchingLocation = true;
    const url = `https://api.weatherapi.com/v1/search.json?key=${apiKey}&q=${encodeURIComponent(query)}`;
    searchLocationProcess.command = ["curl", "-s", url];
    searchLocationProcess.running = true;
  }

  function selectLocation(locationName) {
    Settings.weather.location = locationName;
    location = locationName;
    locationSearchResults = [];
    currentLocationIndex = 0;
    isUserSearching = false;
    updateWeather();
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

          onApiKeyEdited: function (newKey) {
            weatherPanel.apiKey = newKey;
            weatherPanel.apiKeyValidateTimer.restart();
          }

          onLocationTextEdited: function (newText) {
            weatherPanel.location = newText;
            weatherPanel.searchDebounceTimer.stop();
            if (newText.length >= 2) {
              weatherPanel.searchDebounceTimer.restart();
            } else {
              weatherPanel.locationSearchResults = [];
              weatherPanel.currentLocationIndex = 0;
            }
          }

          onLocationFocusStatusChanged: function (hasFocus) {
            if (hasFocus) {
              weatherPanel.isUserSearching = true;
            } else {
              hideResultsTimer.restart();
            }
          }

          onSearchLocationRequested: function (query) {
            weatherPanel.searchLocation(query);
          }

          onLocationSelected: function (locationName) {
            weatherPanel.selectLocation(locationName);
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
              Layout.preferredHeight: parent.height / 2
            }

            // 3-day forecast
            Com.WeatherForecastList {
              Layout.preferredHeight: parent.height / 2
              theme: weatherPanel.theme
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
      if (currentLocationIndex > 0)
      currentLocationIndex--;
      else
      currentLocationIndex = locationSearchResults.length - 1;
    }
  }

  Shortcut {
    sequence: "Down"
    enabled: locationSearchResults.length > 0
    onActivated: {
      if (currentLocationIndex < locationSearchResults.length - 1)
      currentLocationIndex++;
      else
      currentLocationIndex = 0;
    }
  }

  Shortcut {
    sequence: "Return"
    enabled: locationSearchResults.length > 0
    onActivated: {
      var item = locationSearchResults[currentLocationIndex];
      if (item)
      selectLocation(`${item.name},${item.country}`);
    }
  }
  Component.onCompleted: {
    if (apiKey && location) {
      updateWeather();
    }
  }
}
