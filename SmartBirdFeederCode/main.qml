import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "Smart Bird Feeder"

    // Debugging text element to confirm QML is loaded
    Text {
        text: "QML Loaded!"
        anchors.centerIn: parent
        font.pixelSize: 20
        color: "red"
    }

    // Image element to display the webcam frame
    Image {
        id: webcamImage
        width: parent.width
        height: parent.height - 100  // Adjust height to make space for buttons
    }

    // Button to start the webcam
    Button {
        text: "Start Webcam"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50  // Adjust margin to position the button
        onClicked: {
            console.log("Start Webcam Button Clicked")  // Check if the button is clicked
            //webcamHandler.start_webcam()
        }
    }

    // Button to stop the webcam
    Button {
        text: "Stop Webcam"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        onClicked: {
            console.log("Stop Webcam Button Clicked")  // Check if the button is clicked
            //webcamHandler.stop_webcam()
        }
    }
}
