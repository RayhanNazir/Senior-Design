import sys
from PySide6.QtCore import QObject
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication
from webcam import WebcamHandler  # Assuming the webcam handler is correct

class App:
    def __init__(self):
        self.app = QApplication(sys.argv)
        self.engine = QQmlApplicationEngine()

        # Initialize webcam handler
        self.webcam_handler = WebcamHandler()

        # Register the webcam_handler with the QML engine as a context property
        self.engine.rootContext().setContextProperty("webcamHandler", self.webcam_handler)

        # Load QML
        self.engine.load("main.qml")

        # Check if the QML file loaded successfully
        if not self.engine.rootObjects():
            print("Error: Failed to load QML.")
            sys.exit(-1)

        print("QML Loaded Successfully")

    def run(self):
        sys.exit(self.app.exec())

if __name__ == "__main__":
    app = App()
    app.run()
