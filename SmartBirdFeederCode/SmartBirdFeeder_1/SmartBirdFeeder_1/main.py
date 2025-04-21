import sys
from pathlib import Path
from PySide6.QtGui import QGuiApplication        # base class for all Qt GUI applications
from PySide6.QtQml import QQmlApplicationEngine  # loads and manages QML UI files
from backend import PythonBackend, SightingsModel, get_bird_stats, RecentSightingsModel,StatsModel, AppControl # Import the backend module
import os
import subprocess
from src.camera_handler import CameraHandler  # Import the CameraHandler class
os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"  # Set a non-native Qt Quick Controls style

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)     # create a GUI application, sys.argv allows command-line arguments
    engine = QQmlApplicationEngine()    # create a QML application engine, loads and runs QML UI files

    # Set up CameraHandler
    camera_handler = CameraHandler()

    db_config = {
        "host": "localhost",
        "user": "root",
        "password": "bird123",
        "database": "test"
    }


    app_control = AppControl()
    engine.rootContext().setContextProperty("appControl", app_control)
    # Expose CameraHandler to QML
    engine.rootContext().setContextProperty("cameraHandler", camera_handler)

    # Create and register backend with QML
    backend = PythonBackend()
    engine.rootContext().setContextProperty("pythonInterface", backend)

    model = SightingsModel()
    engine.rootContext().setContextProperty("sightingsModel", model)

    stats_model = StatsModel()
    engine.rootContext().setContextProperty("statsModel", stats_model)

    recent_model = RecentSightingsModel()
    engine.rootContext().setContextProperty("recentSightingsModel", recent_model)

    qml_file = Path(__file__).resolve().parent / "main.qml"     # constructs absolute path to the main.qml file
    engine.load(qml_file)               # loads the QML file into the engine, which initializes the UI

    if not engine.rootObjects():     # if loading QML file fails (file not found or syntax error) exit with an error code
        sys.exit(-1)

    print("Py: Application started successfully!")  # Another debug message





    sys.exit(app.exec())




    # start the application event loop, keeps the application running until it is manually closed
