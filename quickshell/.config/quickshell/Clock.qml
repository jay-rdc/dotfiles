import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
  id: root

  MarginWrapperManager {}

  Column {
    Text {
      text: Qt.formatDateTime(Utils.clock.date, "HH:mm")
      font.family: Utils.defaultFont
      font.pixelSize: 110
      color: "white"
      anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
      text: Qt.formatDateTime(Utils.clock.date, "dddd, MMMM d, yyyy")
      font.family: Utils.defaultFont
      font.pixelSize: 25
      color: "white"
      anchors.horizontalCenter: parent.horizontalCenter
    }
  }
}
