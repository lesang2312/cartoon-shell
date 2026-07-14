pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.commons

Singleton {
    function playSound(name) {
        if (clickProcess.running)
            return

        clickProcess.command = [
            "pw-play",
            Directories.assetsPath + "/sounds/" + name + ".wav"
        ]

        clickProcess.running = true
    }

    Process {
        id: clickProcess
        running: false
    }
}
