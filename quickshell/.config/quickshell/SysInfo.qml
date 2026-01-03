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
      //                      CPU                                                   Dedicated GPU
      "sensors | awk '/k10temp-pci-00c3/,/Tccd1/ {if ($1 == \"Tccd1:\") print $2} /amdgpu-pci-0300/,/edge/ {if ($1 == \"edge:\") print $2}' | tr -d '+'; " +

      // [2] CPU usage
      "top -bn1 | grep 'Cpu(s)' | awk '{print $2}'; " +

      // [3] GPU usage
      "cat /sys/class/drm/card1/device/gpu_busy_percent; " +

      // [4] RAM usage (<used GiB>␣<total GiB>)
      "free -m | awk '/Mem:/ {print $3 \" \" $2}'"
    ]

    stdout: StdioCollector {
      id: hwCollector
      waitForEnd: true 

      onStreamFinished: {
        const output = hwCollector.text.trim();
        if (!output) return;

        const lines = output.split("\n");

        if (lines.length >= 5) {
          root.cpuTemp = lines[0];
          root.gpuTemp = lines[1];

          root.cpuUsage = (Math.ceil(parseFloat(lines[2].trim()))) + "%";
          root.gpuUsage = lines[3].trim() + "%";

          const memParts = lines[4].split(" ");
          const usedMiB = parseFloat(memParts[0]);
          const totalMiB = parseFloat(memParts[1]);

          const usedGiB = (usedMiB / 1024).toFixed(2);
          const totalGiB = (totalMiB / 1024).toFixed(2);
          const memPct = ((usedMiB / totalMiB) * 100).toFixed(0);

          root.memFullString = `${usedGiB} GiB / ${totalGiB} GiB (${memPct}%)`;
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
