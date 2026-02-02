import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    // ===== Public API =====
    property real cpuPercent: 0

    property bool enableCpuHistory: true   // 🔥 bật / tắt history
    property var cpuHistory: []
    property int maxHistoryLength: 50

    // ===== Internal =====
    Process {
        id: cpuProcess

        command: ["bash", "-c", "vmstat 1 2 | tail -1 | awk '{print 100 - $15}'"]

        stdout: StdioCollector {
            onTextChanged: {
                const value = parseFloat(text.trim());
                if (isNaN(value))
                    return;

                // luôn cập nhật CPU %
                root.cpuPercent = value;

                // chỉ lưu history khi được bật
                if (!root.enableCpuHistory)
                    return;
                const history = root.cpuHistory.slice();
                history.push({
                    timestamp: Date.now(),
                    usage: value
                });

                if (history.length > root.maxHistoryLength) {
                    history.shift();
                }

                root.cpuHistory = history;
            }
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            if (!cpuProcess.running) {
                cpuProcess.running = true;
            }
        }
    }

    // 🔹 Khi tắt history → clear luôn
    onEnableCpuHistoryChanged: {
        if (!enableCpuHistory) {
            cpuHistory = [];
        }
    }
}
