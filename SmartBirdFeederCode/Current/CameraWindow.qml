import QtQuick 6.8
import QtQuick.Controls 6.8
import QtMultimedia 6.8
import QtQuick.Dialogs 6.8

Window {
    id: cameraWindow
    visible: true
    width: 1000
    height: 600
    title: "Bird Identifier"
    color: "#2C3E50"

    CaptureSession {
        id: captureSession
        imageCapture: ImageCapture {
            id: imageCapture
        }
        camera: Camera {
            id: camera
            Component.onCompleted: {
                console.log("Camera initialized:", cameraDevice.description)
            }
            onActiveChanged: {
                viewfinderText.visible = !active
            }
        }
        videoOutput: videoOutput
    }

    Row {
        spacing: 20
        anchors.centerIn: parent

        // Camera Viewfinder
        Rectangle {
            id: cameraViewfinder
            width: 400
            height: 300
            color: "#1E2A38"
            border.color: "#1ABC9C"
            border.width: 2
            radius: 10

            VideoOutput {
                id: videoOutput
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectFit
                visible: camera.active  // Hide viewfinder when camera is off
            }

            Text {
                id: viewfinderText
                text: "Camera Viewfinder"
                color: "#ECF0F1"
                font.pixelSize: 20
                anchors.centerIn: parent
                visible: !camera.active  // Show text when camera is off
            }
        }

        // Display Prediction Image & Info
        Column {
            spacing: 10

            Image {
                id: predictionImage
                width: 400
                height: 300
                source: "placeholder.jpg"
                fillMode: Image.PreserveAspectFit
                cache: false  // Prevents image caching issues
            }

            Text {
                id: predictionText
                text: "Prediction: N/A"
                color: "#ECF0F1"
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: confidenceText
                text: "Confidence: N/A"
                color: "#ECF0F1"
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    // Camera Control Buttons
    Row {
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        Button {
            text: "Start Camera"
            width: 150
            height: 50
            background: Rectangle {
                color: "#1ABC9C"
                radius: 10
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                font.bold: true
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: camera.active = true  // Start camera
        }

        Button {
            text: "Stop Camera"
            width: 150
            height: 50
            background: Rectangle {
                color: "#E74C3C"  // Red for stop
                radius: 10
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                font.bold: true
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: camera.active = false  // Stop camera
        }

        Button {
            text: "Upload Image"
            width: 150
            height: 50
            background: Rectangle {
                color: "#ffc40c"
                radius: 10
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                font.bold: true
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: fileDialog.open()
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select an image"
        fileMode: FileDialog.OpenFile
        nameFilters: ["Images (*.png *.jpg *.jpeg)"]
        onAccepted: {
            let filePath = selectedFile.toString().replace("file:///", "");     // NEEDS to be "file:///" for some reason an extra / needs to be removed or the image will not be read
            console.log("Selected file:", filePath);
            pythonInterface.processImage(filePath);
        }
    }

    Connections {
        target: pythonInterface
        function onImageUpdated(imagePath, prediction, confidence) {
            console.log("Updated Image Path:", imagePath);
            console.log("Prediction:", prediction);
            console.log("Confidence:", confidence);

            predictionImage.source = ""; // Reset to force update
            predictionImage.source = imagePath; // Load new image
            predictionText.text = "Prediction: " + prediction;
            confidenceText.text = "Confidence: " + confidence.toFixed(2) + "%";
        }
    }
}
