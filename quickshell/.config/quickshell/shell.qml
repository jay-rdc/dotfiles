import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
  Variants {
    model: Quickshell.screens.filter(screen => screen.name === "DP-2")
    PanelWindow {
      id: window

      required property var modelData
      screen: modelData

      exclusionMode: ExclusionMode.Ignore

      WlrLayershell.layer: WlrLayer.Bottom

      implicitWidth: widgets.width
      implicitHeight: widgets.height
      color: "transparent"

      anchors {
        top: true
        left: true
        right: true
      }

      Column {
        id: widgets
        spacing: 8
        anchors.horizontalCenter: parent.horizontalCenter

        Clock { anchors.horizontalCenter: parent.horizontalCenter }
        SysInfo { anchors.horizontalCenter: parent.horizontalCenter }
      }
    }
  }

	LockContext {
		id: lockContext
		onUnlocked: {
			lock.locked = false;
		}
	}

	WlSessionLock {
		id: lock
    WlSessionLockSurface {
      LockSurface {
        anchors.fill: parent
        context: lockContext
      }
    }
	}

  IpcHandler {
    target: "lockscreen"
    function setLocked(state: bool): void {
      lock.locked = state;
    }
  }
}
