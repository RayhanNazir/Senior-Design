import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Window {
    visible: true
    width: 900
    height: 600
    color: "#2C3E50"
    title: qsTr("Bird Sightings")

    Component.onCompleted: sightingsModel.fetch_sightings()

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout
        {
            Layout.alignment: Qt.AlignLeft
            spacing: 10

            Button {
                text: "Refresh"
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
                onClicked: sightingsModel.fetch_sightings()
            }

            Button {
                text: "Clear All Sightings"
                background: Rectangle {
                    color: "#E74C3C"
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
                onClicked: sightingsModel.clear_database()
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                width: parent.width
                height: parent.height
                model: sightingsModel
                spacing: 10
                clip: true

                delegate: Frame {
                    width: parent.width
                    padding: 10
                    background: Rectangle {
                        color: "#34495E"  // dark card background
                        border.color: "#1ABC9C"
                        radius: 10
                    }

                    RowLayout {
                        spacing: 12

                        Rectangle {
                            width: 100
                            height: 100
                            radius: 8
                            clip: true
                            color: "#2C3E50"

                            Image {
                                anchors.fill: parent
                                source: image
                                fillMode: Image.PreserveAspectFit
                                visible: image !== ""
                            }
                        }

                        ColumnLayout {
                            spacing: 4
                            Label {
                                text: "Name: " + name
                                color: "#ECF0F1"
                                font.bold: true
                                font.pixelSize: 16
                            }
                            Label { text: "Time: " + time; color: "#ECF0F1" }
                            Label { text: "Location: " + location; color: "#ECF0F1" }
                            Label { text: "Confidence: " + confidence_percentage + "%"; color: "#ECF0F1" }
                        }
                    }
                }
            }
        }
    }

}
