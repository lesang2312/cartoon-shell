import QtQuick
import qs.commons


Item {
    property var listCategories: [
      {
            categoryName: "General",
            items: [
                { name: "Language & Region", icon: Directories.assetsPath + "/settings/languages.png", category: "language" },
                { name: "Date & Time", icon: Directories.assetsPath + "/settings/time.png", category: "datetime" },
                { name: "Startup", icon: Directories.assetsPath + "/settings/startup.png", category: "session" },
                { name: "Behavior", icon: Directories.assetsPath + "/settings/behavior.png", category: "behavior" },
                { name: "Notifications", icon: Directories.assetsPath + "/settings/notification.png", category: "notifications" },
                { name: "Privacy", icon: Directories.assetsPath + "/settings/privacy.png", category: "privacy" },
            ]
        },
        {
            categoryName: "Appearance",
            items: [
                { name: "Theme", icon: Directories.assetsPath + "/settings/theme.png", category: "theme" },
                { name: "Panel", icon: Directories.assetsPath + "/settings/layout.png", category: "panel" },
                { name: "Clock", icon: Directories.assetsPath + "/settings/clock.png", category: "clock" },
                { name: "Fonts", icon: Directories.assetsPath + "/settings/fonts.png", category: "fonts" },
                { name: "Icons", icon: Directories.assetsPath + "/settings/icons.png", category: "icons" },
                { name: "Effects", icon: Directories.assetsPath + "/settings/effects.png", category: "effects" },
                { name: "Layout", icon: Directories.assetsPath + "/settings/layout.png", category: "layout" },
                { name: "Wallpaper", icon: Directories.assetsPath + "/settings/Wallpaper.png", category: "wallpaper" }
            ]
        }
        
    ]
    
    // ListCategories[1].items[3].name // "Behavior"
}
