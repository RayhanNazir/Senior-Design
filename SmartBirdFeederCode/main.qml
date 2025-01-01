import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: "SmartBirdFeeder"

    Rectangle {
        anchors.fill: parent  // Fill the entire window
        color: "green"        // Initial color of the background
        id: background        // Unique ID for this Rectangle

        Button {
            text: "Change Color"
            anchors.centerIn: parent   // Position the button at the center

            onClicked: {
                background.color = "red";
            }
        }
    }
}
