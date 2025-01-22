import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Smart Bird Feeder"
    color: "#F3F4F6"

    Column {
        anchors.centerIn: parent
        spacing: 15

        // Title Text
        Text {
            text: "Smart Bird Feeder"
            font.pixelSize: 28
            font.bold: true
            color: "#2C3E50"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Description Text
        Text {
            text: "A project to monitor and study bird activity using smart technology."
            font.pixelSize: 16
            font.family: "Arial"
            color: "#34495E"
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap
            width: parent.width * 0.9
        }

        Button {
            width: 150
            height: 50
            anchors.horizontalCenter: parent.horizontalCenter

            background: Rectangle {
                color: "#1ABC9C" // Button color
                radius: 10
            }
            contentItem: Text {
                text: "Open Camera"
                color: "white" // Button text color
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 18
                font.bold: true
            }

            onClicked: {
                console.log("Camera button clicked")

                // Create and show the new window
                var component = Qt.createComponent("CamDisplay.qml")
                if (component.status === Component.Ready) {
                    var camWindow = component.createObject(null)
                    camWindow.show()
                } else {
                    console.log("Error loading CamDisplay.qml: " + component.errorString())
                }
            }

        }

    }
}
