#Testing project setup for QML and Python

import sys
from PySide6.QtWidgets import QApplication


if __name__ == "__main__":
    app = QApplication(sys.argv)
    # ...
    sys.exit(app.exec())
