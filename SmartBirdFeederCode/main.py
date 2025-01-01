# Testing project setup for QML and Python

import sys
from PySide6.QtWidgets import QApplication              # QApplication is the core class for GUI applications. Manages app-wide resources and settings.
from PySide6.QtQml import QQmlApplicationEngine         # QQmlApplicationEngine is used to load and display QML files.

if __name__ == "__main__":           # Check if this script is the main entry point of the program
    app = QApplication(sys.argv)     # QApplication is required for any Qt-based application. It initializes the GUI environment and handles system events like mouse clicks and keypresses.
    engine = QQmlApplicationEngine() # QQmlApplicationEngine is responsible for loading and displaying the QML UI. It bridges the QML front end with the Python backend.

    engine.load("main.qml")          # The load() method tells the engine to load and render the specified QML file. This determines the main user interface of the application.

    if not engine.rootObjects():     # The root object is the top-level UI element in the QML file (ApplicationWindow).
        sys.exit(-1)                 # If the root object is not created (missing or invalid QML file) error code (-1).
    sys.exit(app.exec())             # app.exec() starts the event loop, which keeps the application running and responsive to user actions.

