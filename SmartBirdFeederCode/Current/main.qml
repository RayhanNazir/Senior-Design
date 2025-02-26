// Smart Bird Feeder v1
// Ethan Van Deusen & Rayhan Nazir

// main.qml is the main UI file, contains UI components and basic interactions, for more complicated actions the components are connected to Python functions

import QtQuick 6.8
import QtQuick.Controls 6.8

Window {
    id: mainWindow
    visible: true
    width: 800
    height: 500
    title: "Smart Bird Feeder"
    color: "#2C3E50"

    FontLoader {
        id: customFont
        source: "fonts/Montserrat-Bold.ttf"
    }

    // Main layout container
    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            id: titleText
            text: "Smart Bird Feeder"
            font.pixelSize: 32
            font.family: customFont.name
            color: "#1ABC9C"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: descText
            text: "Monitor and track birds with our smart feeder!"
            font.pixelSize: 18
            font.family: "Arial"
            color: "#ECF0F1"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id: menuBar
            width: parent.width
            height: 50
            color: "#34495E"

            Row {
                anchors.centerIn: parent
                spacing: 20

                Button {
                    font.pixelSize: 16
                    font.bold: true
                    background: Rectangle {
                        color: "#1ABC9C"
                        radius: 10
                    }
                    contentItem: Text {
                        text: "Open Camera Window"
                        color: "white"
                        font.pixelSize: parent.font.pixelSize
                        font.bold: parent.font.bold
                        anchors.centerIn: parent
                    }
                    onClicked: {
                        console.log("Open Camera Window button pressed")
                        var cameraWindowComponent = Qt.createComponent("CameraWindow.qml")
                        if (cameraWindowComponent.status === Component.Ready) {
                            var cameraWindow = cameraWindowComponent.createObject(mainWindow)
                            cameraWindow.show()
                        } else {
                            console.log("Error loading CameraWindow.qml")
                        }
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        console.log("Main Window Created");
    }
}
