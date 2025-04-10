// Smart Bird Feeder v1
// Ethan Van Deusen & Rayhan Nazir

import QtQuick 6.8
import QtQuick.Controls 6.8

Window {
    id: mainWindow
    visible: true
    width: 1200
    height: 900
    title: "Smart Bird Feeder"
    color: "#2C3E50"


    Button {
        text: "Refresh"
        onClicked: {
            recentSightingsModel.fetch()
            statsModel.fetch()
        }

        width: 150
        height: 40
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 20
        anchors.rightMargin: 20

        background: Rectangle {
            color: "#1ABC9C"
            radius: 10
        }

        contentItem: Text {
            text: parent.text
            color: "white"
            font.bold: true
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    FontLoader {
        id: montserratBold
        source: "fonts/Montserrat-Bold.ttf"
    }
    FontLoader {
        id: montserratReg
        source: "fonts/Montserrat-VariableFont_wght.ttf"
    }
    Row {
        anchors.topMargin: 20
        anchors.top: titleText.bottom
        spacing: 20

        // Menu button
        Button {
            id: menuButton
            text: "☰"
            width: 50
            height: 50
            background: Rectangle {
                color: "#1ABC9C"
                radius: 10
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 24
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: menuDrawer.open()
        }
    }

    Drawer {
        id: menuDrawer
        width: 250
        height: parent.height
        edge: Qt.LeftEdge
        contentItem: Column {
            spacing: 20
            anchors.fill: parent
            padding: 10

            Button {
                text: "Open Camera Window"
                font.pixelSize: 16
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

            Button {
                text: "Database"
                font.pixelSize: 16
                onClicked: {
                    var component = Qt.createComponent("DetailsWindow.qml");
                    if (component.status === Component.Ready) {
                        var win = component.createObject(mainWindow);
                        if (win) {
                            win.show();
                        } else {
                            console.log("createObject failed:", component.errorString());
                        }
                    } else {
                        console.log("Component load failed:", component.errorString());
                    }
                }
            }

            Button {
                text: "Custom Identification"
                font.pixelSize: 16
                onClicked: {
                    console.log("Open Custom Identification window")
                    var customIdWindowComponent = Qt.createComponent("CustomId.qml")
                    if (customIdWindowComponent.status === Component.Ready) {
                        var customIdWindow = customIdWindowComponent.createObject(mainWindow)
                        customIdWindow.show()
                    } else {
                        console.log("Error loading CustomId.qml")
                    }
                }
            }
        }
    }

    // Main layout container
    Column {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Text {
            id: titleText
            text: "Neural Nest"
            font.pixelSize: 32
            font.family: montserratBold.name
            color: "#1ABC9C"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: nameText
            text: "By: Rayhan Nazir and Ethan Van Deusen"
            font.pixelSize: 16
            font.family: montserratReg.name
            color: "#1ABC9C"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle {
            width: 200
            height: 200
            color: "#34495E"
            radius: 10
            border.color: "#1ABC9C"
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                anchors.fill: parent
                anchors.margins: 10 // Padding
                Image {
                    id: predictionImage
                    source: "images/LogoIcon.png"
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        Row {
            anchors.top: menuButton.bottom
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 40

            Rectangle {
                width: 400
                height: 390
                color: "#34495E"
                radius: 10
                border.color: "#1ABC9C"

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Text {
                        text: "Stats Window"
                        color: "#ECF0F1"
                        font.pixelSize: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: "Total Birds Seen: " + statsModel.totalBirds
                        color: "#ECF0F1"
                        font.pixelSize: 16
                    }
                    Text {
                        text: "Unique Species: " + statsModel.uniqueSpecies
                        color: "#ECF0F1"
                        font.pixelSize: 16
                    }
                    Text {
                        text: "Most Frequent: " + statsModel.mostFrequent
                        color: "#ECF0F1"
                        font.pixelSize: 16
                    }
                    Text {
                        text: "Last Seen: " + statsModel.lastSeen
                        color: "#ECF0F1"
                        font.pixelSize: 16
                    }

                    Item {
                        width: parent.width
                        height: 160

                        Image {
                            source: statsModel.lastSeenImage
                            cache: false
                            visible: statsModel.lastSeenImage !== ""
                            width: 160
                            height: 160
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }

            Rectangle {
                id: recentlySightedWidget
                width: 400
                height: 200
                color: "#34495E"
                radius: 10
                border.color: "#1ABC9C"
                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 5
                    Text {
                        text: "Recently Sighted"
                        color: "#ECF0F1"
                        font.pixelSize: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Flickable {
                        id: flickableList
                        width: parent.width
                        height: parent.height - 30
                        contentWidth: rowLayout.width
                        clip: true
                        interactive: true  // Allows manual scrolling

                        Row {
                            id: rowLayout
                            spacing: 10
                            Repeater {
                                model: recentSightingsModel

                                delegate: Column {
                                    width: 120

                                    Image {
                                        source: imagePath
                                        width: 120
                                        height: 120
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    Text {
                                        text: name
                                        color: "#ECF0F1"
                                        font.pixelSize: 14
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }


                                }
                            }
                        }

                        // Timer to control auto-scrolling
                        Timer {
                            id: autoScrollTimer
                            interval: 50 // Controls the speed of scrolling
                            running: true
                            repeat: true
                            onTriggered: {
                                if (flickableList.contentX < flickableList.contentWidth - flickableList.width) {
                                    flickableList.contentX += 1 // Scroll right
                                } else {
                                    flickableList.contentX = 0 // Reset scroll to beginning
                                }
                            }
                        }

                        // Restart auto-scroll after user interaction
                        Timer {
                            id: resumeAutoScrollTimer
                            interval: 1500 // Delay before auto-scroll resumes (1.5 seconds)
                            running: false
                            onTriggered: autoScrollTimer.start()
                        }

                        // Stop auto-scroll when user interacts
                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                autoScrollTimer.stop()
                                resumeAutoScrollTimer.restart() // Restart auto-scroll after delay
                            }
                        }
                    }
                }
            }
        }
    }
}
