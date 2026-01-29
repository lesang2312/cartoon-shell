pragma Singleton

import QtQuick
import Quickshell
import qs.commons

Singleton {
  id: themeService

  readonly property string currentTheme: Settings.appearance.theme
  property var theme: ({})  // theme hiện tại
  property bool isInitialized: false

  signal themeReloaded()     // signal thông báo theme đã thay đổi

  Connections {
    target: Settings.appearance
    function onThemeChanged() {
      if (isInitialized) {
        themeService.loadTheme();
      }
    }
  }

  function init() {
    console.log("Initializing ThemeService...");
    theme = {};
    isInitialized = true;
    loadTheme();
  }

  function loadTheme() {
    if (!isInitialized) return;
    
    var filePath = Qt.resolvedUrl("../assets/themes/" + currentTheme + ".json")
    var xhr = new XMLHttpRequest()
    xhr.open("GET", filePath, false)
    xhr.send()

    if (xhr.status === 200) {
      try {
        theme = JSON.parse(xhr.responseText)
        console.log("Theme loaded successfully:", currentTheme);
      } catch (e) {
        console.error("Failed to parse theme JSON:", e);
        theme = getFallbackTheme()
      }
    } else {
      console.error("Failed to load theme file:", filePath);
      theme = getFallbackTheme()
    }

    themeReloaded()
    return theme
  }

  function changeTheme(newTheme) {
    if (newTheme !== currentTheme) {
      Settings.appearance.theme = newTheme
    }
    return loadTheme()
  }

  function getFallbackTheme() {
    return {
      "primary": { "background": "#ffffff", "foreground": "#000000" },
      "normal": { "black": "#000000", "white": "#ffffff" },
      "cursor": { "cursor": "#000000", "text": "#ffffff" }
    }
  }

}
