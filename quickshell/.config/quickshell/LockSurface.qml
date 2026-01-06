import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell.Wayland

Rectangle {
	id: root
	required property LockContext context
	readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

	color: "black"

  // NOTE: uncomment for debugging
  // Button {
	// 	text: "Its not working, let me out"
	// 	onClicked: context.unlocked();
	// }

  Column {
    visible: Window.active
    spacing: 50
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
          text: "Unlock"
          padding: 10

          // don't steal focus from the text box
          focusPolicy: Qt.NoFocus

          enabled: !root.context.unlockInProgress && root.context.currentText !== "";
          onClicked: root.context.tryUnlock();

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
            radius: 2
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
