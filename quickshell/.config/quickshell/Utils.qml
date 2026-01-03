pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  readonly property alias clock: clock
  readonly property string defaultFont: "Mononoki Nerd Font"

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
