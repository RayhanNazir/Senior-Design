import sys
#import cv2
#import numpy as np
from PySide6.QtCore import QObject, Signal, Slot
from roboflow import Roboflow

class PythonBackend(QObject):
    imageUpdated = Signal(str, str, float)  # Signal with image path, prediction, confidence

    def __init__(self):
        super().__init__()
        self.rf = Roboflow(api_key="5HCjSD7r7g2tqXtSHPXA")  # Roboflow API Key
        self.project = self.rf.workspace().project("bird-v2")  # Load Project
        self.model = self.project.version(2).model  # Load model version

    @Slot(str)
    def processImage(self, image_path):
        """Runs the bird detection model on the uploaded image."""
        try:
            print(f"Processing image: {image_path}")

            # Run inference with Roboflow API
            result = self.model.predict(image_path, confidence=40, overlap=30).json()

            # Extract prediction info (if any)
            if result["predictions"]:
                prediction = result["predictions"][0]["class"]  # Bird species
                confidence = result["predictions"][0]["confidence"] * 100  # Convert to percentage
            else:
                prediction = "Unknown"
                confidence = 0.0

            # Save annotated image
            output_path = "images/prediction.jpg"
            self.model.predict(image_path, confidence=40, overlap=30).save(output_path)

            print(f"Prediction: {prediction}, Confidence: {confidence}%")
            self.imageUpdated.emit(output_path, prediction, confidence)  # Emit updated data

        except Exception as e:
            print(f"Error processing image: {e}")

if __name__ == "__main__":
    from PySide6.QtWidgets import QApplication
    from PySide6.QtQml import QQmlApplicationEngine

    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    backend = PythonBackend()
    engine.rootContext().setContextProperty("pythonInterface", backend)

    engine.load("CameraWindow.qml")

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
