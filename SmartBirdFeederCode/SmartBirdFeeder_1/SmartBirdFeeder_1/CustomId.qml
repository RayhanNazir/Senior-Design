import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Dialogs 6.8

Window {
    id: customIDWindow
    visible: true
    width: 1000
    height: 600
    title: "Custom Identification"
    color: "#2C3E50"

    Row {
        spacing: 20
        anchors.fill: parent
        anchors.margins: 20

        // Left Column: Upload section and results
        Column {
            spacing: 20
            width: parent.width * 0.6

            // Title
            Text {
                text: "Custom Bird Identification"
                color: "#ECF0F1"
                font.pixelSize: 24
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }

            // Instructions/Description
            Text {
                text: "Upload an image of a bird to have it identified. Once the image is processed, the prediction and confidence level will be displayed."
                color: "#ECF0F1"
                font.pixelSize: 16
                wrapMode: Text.WordWrap
                width: parent.width * 0.9
                horizontalAlignment: Text.AlignHCenter
            }

            // Display Area for Image & Results
            Image {
                id: predictionImage
                width: 400
                height: 300
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

            Row {
                spacing: 20
                Button {
                    text: "Upload Image"
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
                    onClicked: fileDialog.open()
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
                        predictionImage.source = "images/placeholder.jpg"
                        predictionText.text = "Prediction: N/A"
                        confidenceText.text = "Confidence: N/A";

                    }
                }
            }

            FileDialog {
                id: fileDialog
                title: "Select an image"
                fileMode: FileDialog.OpenFile
                nameFilters: ["Images (*.png *.jpg *.jpeg)"]
                onAccepted: {
                    let filePath = selectedFile.toString().replace("file:///", "");
                    console.log("Selected file:", filePath);
                    pythonInterface.processImage(filePath);
                }
            }
        }

        // Right Column: Bird Info Section
        Rectangle {
            width: parent.width * 0.35
            height: parent.height
            color: "#34495E"
            radius: 10
            border.color: "#1ABC9C"

            Column {
                spacing: 10
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: "Bird Information"
                    color: "#ECF0F1"
                    font.pixelSize: 20
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }

                Text {
                    text: "Once a bird is identified, more info will appear here. This will include tracking data such as how many times this bird has been spotted and in the future will include more info about the type of bird "
                    color: "#ECF0F1"
                    font.pixelSize: 14
                    wrapMode: Text.WordWrap
                    width: parent.width * 0.9
                    horizontalAlignment: Text.AlignHCenter
                }

                Rectangle {
                    width: parent.width * 0.9
                    height: 150
                    color: "#2C3E50"
                    radius: 10
                    border.color: "#1ABC9C"
                    // No anchors here so Column manages placement
                    Text {
                        text: "Detailed Bird Info will be displayed here."
                        color: "#ECF0F1"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                    }
                }
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

            // Example: Update bird info (to be expanded later)
        }
    }
}
