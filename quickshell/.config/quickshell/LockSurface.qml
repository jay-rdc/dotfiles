import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io

Rectangle {
	id: root
	required property LockContext context

	color: "black"

  // NOTE: uncomment for debugging
  // Button {
	// 	text: "Its not working, let me out"
	// 	onClicked: context.unlocked();
	// }

  Process {
    id: turnOffMonitors
    command: [ "sh", "-c", "niri msg action power-off-monitors" ]
  }

  Column {
    visible: Window.active
    spacing: 30
    topPadding: -300
    anchors.centerIn: parent

    Column {
      anchors.horizontalCenter: parent.horizontalCenter

      Text {
        text: ""
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: Utils.defaultFont
        font.pixelSize: 80
        color: "white"
      }

      Clock { anchors.horizontalCenter: parent.horizontalCenter }

      WrapperItem {
        anchors.horizontalCenter: parent.horizontalCenter
        topMargin: 20

        Button {
          id: offMonitorBtn
          text: "󰶐  Turn Off Monitors"
          padding: 10
          focusPolicy: Qt.NoFocus
          enabled: !root.context.unlockInProgress
          onClicked: turnOffMonitors.running = true;

          contentItem: Text {
            text: offMonitorBtn.text
            font.family: Utils.defaultFont
            font.pixelSize: 16
            color: enabled ? "white" : "gray"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
          }

          background: Rectangle {
            implicitWidth: 100
            implicitHeight: 40
            color: "black"
            border.color: enabled ? "white" : "gray"
            border.width: 1
            radius: 4
          }
        }
      }
    }

    ColumnLayout {
      RowLayout {
        TextField {
          id: passwordBox

          implicitWidth: 300
          padding: 10

          focus: true
          enabled: !root.context.unlockInProgress
          echoMode: TextInput.Password
          inputMethodHints: Qt.ImhSensitiveData
          onTextChanged: root.context.currentText = this.text;
          onAccepted: root.context.tryUnlock();

          background: Rectangle {
            color: enabled ? "white" : "gray"
            border.color: enabled ? "white" : "gray"
            border.width: 1
          }

          // Update the text in the box to match the text in the context.
          // This makes sure multiple monitors have the same text.
          Connections {
            target: root.context

            function onCurrentTextChanged() {
              passwordBox.text = root.context.currentText;
            }
          }
        }

        Button {
          id: unlockBtn
          text: " Unlock"
          padding: 10

          // don't steal focus from the text box
          focusPolicy: Qt.NoFocus

          onClicked: root.context.tryUnlock();
          enabled: {
            !root.context.unlockInProgress && root.context.currentText !== "";
          }

          contentItem: Text {
            text: unlockBtn.text
            font.family: Utils.defaultFont
            font.pixelSize: 16
            color: enabled ? "white" : "gray"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
          }

          background: Rectangle {
            implicitWidth: 100
            implicitHeight: 40
            color: "black"
            border.color: enabled ? "white" : "gray"
            border.width: 1
            radius: 4
          }
        }
      }

      Text {
        visible: root.context.showFailure
        text: "Incorrect password"
        font.family: Utils.defaultFont
        font.pixelSize: 16
        color: "#ef2929"
      }
    }
  }
}
