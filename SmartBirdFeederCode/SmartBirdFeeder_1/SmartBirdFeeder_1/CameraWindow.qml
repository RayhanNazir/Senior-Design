import QtQuick 6.8
import QtQuick.Controls 6.8
import QtMultimedia 6.8
import Qt.labs.platform 1.1

Window {
    id: cameraWindow
    visible: true
    width: 1000
    height: 600
    title: "Bird Identifier"
    color: "#2C3E50"

    property string globalImagePath: ""


    CaptureSession {
        id: captureSession
        imageCapture: ImageCapture { id: imageCapture }
        camera: Camera {
            id: camera
            active: true
            Component.onCompleted: {
                console.log("Camera initialized:", cameraDevice.description)
            }
            onActiveChanged: {
                viewfinderText.visible = !active
            }
        }
        videoOutput: videoOutput
    }

    // Main layout: left for text info, right for the camera viewfinder.
    Item {
        id: mainContent
        anchors.fill: parent

        Row {
            spacing: 40
            anchors.centerIn: parent


            // Camera viewfinder section with overlay
            Column {
                spacing: 10

                Text {
                    id: birdInfoText
                    text: "No birds"
                    color: "#ECF0F1"
                    font.pixelSize: 18
                    font.bold: true
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Camera viewfinder container
                Rectangle {
                    id: cameraViewfinder
                    width: 400
                    height: 300
                    color: "#1E2A38"
                    border.color: flashing ? "#F1C40F" : "#1ABC9C"
                    border.width: 4
                    radius: 10

                    property bool flashing: false

                    VideoOutput {
                        id: videoOutput
                        anchors.fill: parent
                        fillMode: VideoOutput.PreserveAspectFit
                        visible: camera.active
                    }

                    Text {
                        id: viewfinderText
                        text: "Camera Viewfinder"
                        color: "#ECF0F1"
                        font.pixelSize: 20
                        anchors.centerIn: parent
                        visible: !camera.active
                    }

                    // Flash animation (border flashes yellow)
                    SequentialAnimation {
                        id: flashAnim
                        loops: 9
                        running: false
                        ColorAnimation { target: cameraViewfinder; property: "border.color"; to: "#F1C40F"; duration: 100 }
                        ColorAnimation { target: cameraViewfinder; property: "border.color"; to: "#1ABC9C"; duration: 100 }
                    }


                    // Overlay image appears on top of the viewfinder.
                    Image {
                        id: birdSlideOverlay
                        width: cameraViewfinder.width * 0.7
                        height: cameraViewfinder.height * 0.5
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit
                        source: ""
                        opacity: 0.0
                        visible: false
                        Behavior on opacity {
                            OpacityAnimator { duration: 300 }
                        }
                        Component.onCompleted: console.log("birdSlideOverlay completed, source:", source)
                    }
                }
            }

            Column {
                spacing: 5
                Image {
                    id: predictionImage
                    width: 300
                    height: 200
                    source: "images/placeholder.jpg"
                    fillMode: Image.PreserveAspectFit
                    cache: false
                }

                Text {
                    id: predictionText
                    text: "Prediction: N/A"
                    color: "#ECF0F1"
                    font.pixelSize: 18
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }

                Text {
                    id: confidenceText
                    text: "Confidence: N/A"
                    color: "#ECF0F1"
                    font.pixelSize: 18
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }

            }
        }
    }

    // Timer to fade out the overlay after 3 seconds.
    Timer {
        id: fadeOutTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            birdSlideOverlay.opacity = 0.0;
            console.log("Overlay fade-out triggered");
            pythonInterface.processImage(globalImagePath);


        }
    }

    // Bottom buttons.
    Row {
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        Button {
            text: "Bird Visit"
            width: 150
            height: 50
            background: Rectangle { color: "#1ABC9C"; radius: 10 }
            contentItem: Text {
                text: parent.text
                color: "white"
                font.bold: true
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                const result = pythonInterface.listBirdImages();
                console.log("Bird Visit clicked, result:", result);
                if (result.path !== "") {
                    birdInfoText.text = "Bird visited at " + result.timestamp + "!";
                    birdSlideOverlay.source = result.path;
                    birdSlideOverlay.visible = true;
                    birdSlideOverlay.opacity = 1.0;
                    fadeOutTimer.start();
                    flashAnim.start();
                    globalImagePath = result.path;

                }
            }
        }

        Button {
            text: "Take Picture"
            width: 150
            height: 50
            background: Rectangle { color: "#1ABC9C"; radius: 10 }
            contentItem: Text {
                text: parent.text
                color: "white"
                font.bold: true
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                    let filePath = "D:/QT Projects/SmartBirdFeeder_1/images/temp.png";
                    imageCapture.captureToFile(filePath);
                    console.log("Saved image to: " + filePath);

                    // Start a delay before calling processImage
                    delayTimer.filePathToProcess = filePath;
                    delayTimer.start();
                }

                Timer {
                    id: delayTimer
                    interval: 1000 // 1 second in milliseconds
                    repeat: false
                    property string filePathToProcess: ""

                    onTriggered: {
                        console.log("Processing image after delay:", filePathToProcess);
                        pythonInterface.processImage(filePathToProcess);
                    }
                }


        }


        Button {
            text: "Clear"
            width: 150
            height: 50
            background: Rectangle { color: "#E74C3C"; radius: 10 }
            contentItem: Text {
                text: parent.text
                color: "white"
                font.bold: true
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                birdInfoText.text = "No birds";
                birdSlideOverlay.visible = false;
                console.log("Cleared bird info and overlay");
                globalImagePath = "";
                predictionImage.source = "images/placeholder.jpg"
                predictionText.text = "Prediction: N/A"
                confidenceText.text = "Confidence: N/A";

            }
        }
    }
    Connections {
        target: pythonInterface
        function onImageUpdated(imagePath, prediction, confidence) {
            console.log("Updated Image Path:", imagePath);
            console.log("Prediction:", prediction);
            console.log("Confidence:", confidence);

            predictionImage.source = "";
            predictionImage.source = imagePath;
            predictionText.text = "Prediction: " + prediction;
            confidenceText.text = "Confidence: " + confidence.toFixed(2) + "%";

        }
    }
}
