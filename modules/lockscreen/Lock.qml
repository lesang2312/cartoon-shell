import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Io

Scope {
  id: root
  property bool showLockscreen: false
  LockContext {
    id: lockContext

    onUnlocked: {
      root.showLockscreen = false;
    }
  }

  WlSessionLock {
    id: lock
    locked: root.showLockscreen
    WlSessionLockSurface {
      color: "transparent"
      LockSurface {
        anchors.fill: parent
        context: lockContext
      }
    }
  }
  IpcHandler {
    function lock(): void {
      root.showLockscreen= true;
    }

    function unlock(): void {
      root.showLockscreen= false;
    }

    function isLocked(): bool {
      return root.showLockscreen;
    }
    target: "lock"
  }
}
