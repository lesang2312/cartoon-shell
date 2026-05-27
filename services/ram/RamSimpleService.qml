pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property real ramPercent: 0

  property var ramHistory: []

  property int maxHistoryLength: 50

  Process {
    id: ramProcess

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

        root.ramPercent = value;

        const history = root.ramHistory.slice();

        history.push({
            usage: value
        });

        if (history.length > root.maxHistoryLength)
        history.shift();

        root.ramHistory = history;
      }
    }
  }

  Timer {
    interval: 1000
    repeat: true
    running: true
    triggeredOnStart: true

    onTriggered: {
      if (!ramProcess.running)
      ramProcess.running = true;
    }
  }

}
