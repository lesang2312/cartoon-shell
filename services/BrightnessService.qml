pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real currentBrightness: 0.5
    property bool shouldShowOsd: false

    Component.onCompleted: {
        Qt.callLater(init);
    }

    function init() {
        getBrightProcess.running = true;
    }

    Process {
        id: getBrightProcess
        running: false

        command: [
            "bash",
            "-c",
            "awk \"BEGIN {print $(brightnessctl g)/$(brightnessctl m)}\""
        ]

        stdout: StdioCollector {
            onTextChanged: {
                const value = parseFloat(text.trim());
                if (!isNaN(value)) {
                    root.currentBrightness = value;
                }
            }
        }
    }

    IpcHandler {
        target: "brightness"

        function set(value: real) {
            root.shouldShowOsd = true;
            root.currentBrightness = value;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.shouldShowOsd = false
    }
}
