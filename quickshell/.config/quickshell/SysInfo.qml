import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Item {
  id: root

  readonly property int statsTitleFontSize: 15
  readonly property int statsFontSize: 19

  property string cpuUsage: "0%"
  property string cpuTemp: "0°C"
  property string memFullString: "0 GiB / 0 GiB (0%)"
  property string gpuUsage: "0%"
  property string gpuTemp: "0°C"
  property bool isClipRecording: false

  Process {
    id: hardwareStats
    command: [
      "sh", "-c", 

      // [0, 1] CPU and GPU temps
      //                      CPU                                                                           Dedicated GPU
      "sensors | awk '/k10temp-pci-00c3/,/Tccd1/ {if ($1 == \"Tccd1:\") {gsub(/+/, \"\", $2); print $2}} /amdgpu-pci-0300/,/edge/ {if ($1 == \"edge:\") {gsub(/+/, \"\", $2); print $2; exit}}'; " +

      // [2] CPU usage
      "top -bn 2 -d 0.01 | awk '/^%Cpu/ {i++} i==2 {printf \"%.0f%%\\n\", 100-$8; exit}'; " +

      // [3] GPU usage
      "cat /sys/class/drm/card1/device/gpu_busy_percent; " +

      // [4, 5, 6] RAM usage (<used GiB>\n<total GiB>\n<usage percentage>)
      "free -m | awk '/Mem:/ {printf \"%.2f\\n%.2f\\n%.0f%%\\n\", $3/1024, $2/1024, $3/$2 * 100}'"
    ]

    stdout: StdioCollector {
      id: hwCollector
      waitForEnd: true 

      onStreamFinished: {
        const output = hwCollector.text.trim();
        if (!output) return;

        const lines = output.split("\n");

        if (lines.length >= 7) {
          root.cpuTemp = lines[0];
          root.gpuTemp = lines[1];

          root.cpuUsage = lines[2];
          root.gpuUsage = lines[3].trim() + "%";

          root.memFullString = `${lines[4]} GiB / ${lines[5]} GiB (${lines[6]}%)`;
        }
      }
    }
  }

  Process {
    id: clipStatus
    command: [
      "sh", "-c",
      "pidof -xq gpu-screen-recorder && echo 'true' || echo 'false'"
    ]
    stdout: StdioCollector {
      id: clipCollector
      waitForEnd: true
      onStreamFinished: {
        const output = clipCollector.text.trim();
        if (!output) return;

        root.isClipRecording = output.trim() === "true";
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: hardwareStats.running = true
  }

  // Use a separate timer for clipStatus to see its status change immediately
  Timer {
    interval: 200
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: clipStatus.running = true
  }

  MarginWrapperManager {}

  Column {
    spacing: 8

    Grid {
      columns: 3
      spacing: 20

      Column {
        Text {
          text: "CPU"
          anchors.horizontalCenter: parent.horizontalCenter
          color: "#aaaaaa"
          font.family: Utils.defaultFont
          font.pixelSize: root.statsTitleFontSize
          font.letterSpacing: 1
        }
        Text {
          text: root.cpuUsage + " " + root.cpuTemp
          color: "white"
          font.family: Utils.defaultFont
          font.pixelSize: root.statsFontSize
        }
      }

      Column {
        Text {
          text: "GPU"
          anchors.horizontalCenter: parent.horizontalCenter
          color: "#aaaaaa"
          font.family: Utils.defaultFont
          font.pixelSize: root.statsTitleFontSize
          font.letterSpacing: 1
        }
        Text {
          text: root.gpuUsage + " " + root.gpuTemp
          color: "white"
          font.family: Utils.defaultFont
          font.pixelSize: root.statsFontSize
        }
      }

      Column {
        Text {
          text: "RAM"
          anchors.horizontalCenter: parent.horizontalCenter
          color: "#aaaaaa"
          font.family: Utils.defaultFont
          font.pixelSize: root.statsTitleFontSize
          font.letterSpacing: 1
        }
        Text {
          text: root.memFullString
          color: "white"
          font.family: Utils.defaultFont
          font.pixelSize: root.statsFontSize
        }
      }
    }

    Text {
      text: "Clips: " + (root.isClipRecording ? "ON" : "OFF")
      anchors.horizontalCenter: parent.horizontalCenter
      color: (root.isClipRecording ? "#8ae234" : "#ef2929")
      font.family: Utils.defaultFont
      font.pixelSize: 20
      font.bold: true
    }
  }
}
