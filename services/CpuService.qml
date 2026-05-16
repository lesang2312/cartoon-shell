import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  // ===== Public API =====
  property real cpuPercent: 0

  property bool enableCpuHistory: true
  property bool enableProcessList: false
  property var cpuHistory: []
  property var listAppCpu: []

  property int maxHistoryLength: 50

  // ===== CPU Usage =====
  Process {
    id: cpuProcess

    command: [
    "sh",
    "-c",
    "vmstat 1 2 | awk 'NR==4 {print 100-$15}'"
    ]

    running: false

    stdout: StdioCollector {
      onTextChanged: {
        const value = parseFloat(text.trim());

        if (isNaN(value))
        return;

        root.cpuPercent = value;

        if (!root.enableCpuHistory)
        return;

        const history = root.cpuHistory.slice();

        history.push({
            timestamp: Date.now(),
            usage: value
        });

        if (history.length > root.maxHistoryLength)
        history.shift();

        root.cpuHistory = history;
      }
    }
  }

  // ===== Top CPU Processes =====
  Process {
    id: cpuProcessManager

    command: [
    "bash",
    "-c",
    `
    LC_ALL=C ps -eo pid,comm,pcpu,pmem --no-headers --sort=-pcpu |
    head -n 10 |
    awk '
    {
    gsub(/"/, "\\\\\\"", $2)

    cpu=$3 + 0
    mem=$4 + 0

    printf "{\\"pid\\":%d,\\"name\\":\\"%s\\",\\"cpu\\":%.1f,\\"mem\\":%.1f}\\n",
    $1, $2, cpu, mem
  }' |
    jq -s .
    `
    ]

    running: false

    stdout: StdioCollector {
      id: infoCollector

      onTextChanged: {
        try {
          root.listAppCpu = JSON.parse(text.trim());
        } catch (e) {
          console.log("Parse CPU process error:", e);
        }
      }
    }
  }

  // ===== Update Timer =====
  Timer {
    interval: 1000
    repeat: true
    running: true
    triggeredOnStart: true

    onTriggered: {

      if (!cpuProcess.running)
      cpuProcess.running = true;
      if (!cpuProcessManager.running && root.enableProcessList)
      cpuProcessManager.running = true;

    }
  }

  // ===== Reset History =====
  onEnableCpuHistoryChanged: {
    if (!enableCpuHistory)
    cpuHistory = [];
  }
}
