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

      // [0] CPU usage
      "(grep '^cpu ' /proc/stat; sleep 0.1; grep '^cpu ' /proc/stat) | awk '{t=0; for(i=2;i<=NF;i++) t+=$i; id=$5+$6} NR==1{t1=t; id1=id} NR==2{dt=t-t1; did=id-id1; printf \"%.0f%%\\n\", 100*(dt-did)/dt}'; " +

      // [1] CPU temp
      "awk '{printf \"%.1f°C\\n\", $1/1000}' /sys/class/hwmon/hwmon4/temp3_input; " +

      // [2] GPU usage
      "cat /sys/class/drm/card1/device/gpu_busy_percent; " +

      // [3] GPU temp
      "awk '{printf \"%.1f°C\\n\", $1/1000}' /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input; " +

      // [4, 5, 6] RAM usage (<used GiB>\n<total GiB>\n<usage percentage>)
      "awk '/MemTotal/ {total=$2} /MemAvailable/ {avail=$2} END {used=total-avail; printf \"%.2f\\n%.2f\\n%.0f%\\n\", used/1024/1024, total/1024/1024, used*100/total}' /proc/meminfo"
    ]

    stdout: StdioCollector {
      id: hwCollector
      waitForEnd: true 

      onStreamFinished: {
        const output = hwCollector.text.trim();
        if (!output) return;

        const lines = output.split("\n");

        if (lines.length >= 7) {
          root.cpuUsage = lines[0];
          root.cpuTemp = lines[1];

          root.gpuUsage = lines[2] + "%";
          root.gpuTemp = lines[3];

          root.memFullString = `${lines[4]} GiB / ${lines[5]} GiB (${lines[6]})`;
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
      text: `Clips: ${root.isClipRecording ? "ON" : "OFF"}`
      anchors.horizontalCenter: parent.horizontalCenter
      color: root.isClipRecording ? "#8ae234" : "#ef2929"
      font.family: Utils.defaultFont
      font.pixelSize: 20
      font.bold: true
    }
  }
}
