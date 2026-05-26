import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root
  property var listAppCpu: []
  // ===== Top CPU Processes =====
  Process {
    id: cpuProcess

    command: [
    "bash",
    "-c",
    `
    LC_ALL=C ps -eo pid,comm,pcpu,pmem --no-headers --sort=-pcpu |
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
    interval: 3000
    repeat: true
    running: true
    triggeredOnStart: true

    onTriggered: {

      if (!cpuProcess.running)
      cpuProcess.running = true;
    }
  }
}
