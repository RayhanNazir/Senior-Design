import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: "Camera Display"
    color: "#FFFFFF"

    Column {
        anchors.centerIn: parent
        spacing: 20

        // Display Text
        Text {
            text: "Camera feed will be displayed here."
            font.pixelSize: 18
            color: "#34495E"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        // Start and Stop Buttons
        Row {
            spacing: 15
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: startCam
                width: 100
                height: 40
                font.pixelSize: 16

                background: Rectangle {
                    color: "#1ABC9C"
                    radius: 8
                }
                contentItem: Text {
                    text: "Start Cam"
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 16
                    font.bold: true
                }
                onClicked: {
                    console.log("Start cam button clicked")
                }
            }

            Button {
                id: stopCam
                width: 100
                height: 40

                background: Rectangle {
                    color: "#E74C3C"
                    radius: 8
                }
                contentItem: Text {
                    text: "Stop Cam"
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 16
                    font.bold: true
                }
                onClicked: {
                    console.log("Stop cam button clicked")
                }
            }
        }
    }
}
