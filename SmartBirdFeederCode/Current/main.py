# Smart Bird Feeder v1
# Ethan Van Deusen & Rayhan Nazir

# main.py is the Python Entry point. It loads the QML UI and initializes the app
# this is where data is passed between Python and QML

# to open the virtual enviornment use these commands in the QT Terminal
# 1. cd .qtcreator\Python_3_12_0venv\Scripts
# 2. .\activate

import os

from PySide6.QtQml import QQmlApplicationEngine

import sys
from pathlib import Path
from PySide6.QtGui import QGuiApplication        # base class for all Qt GUI applications
from PySide6.QtQml import QQmlApplicationEngine  # loads and manages QML UI files
from backend import PythonBackend  # Import the backend module

from src.camera_handler import CameraHandler  # Import the CameraHandler class
os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"  # Set a non-native Qt Quick Controls style

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)     # create a GUI application, sys.argv allows command-line arguments
    engine = QQmlApplicationEngine()    # create a QML application engine, loads and runs QML UI files

    # Set up CameraHandler
    camera_handler = CameraHandler()

    # Expose CameraHandler to QML
    engine.rootContext().setContextProperty("cameraHandler", camera_handler)

    # Create and register backend with QML
    backend = PythonBackend()
    engine.rootContext().setContextProperty("pythonInterface", backend)

    qml_file = Path(__file__).resolve().parent / "main.qml"     # constructs absolute path to the main.qml file
    engine.load(qml_file)               # loads the QML file into the engine, which initializes the UI

    if not engine.rootObjects():     # if loading QML file fails (file not found or syntax error) exit with an error code
        sys.exit(-1)

    print("Py: Application started successfully!")  # Another debug message

    sys.exit(app.exec())     # start the application event loop, keeps the application running until it is manually closed
