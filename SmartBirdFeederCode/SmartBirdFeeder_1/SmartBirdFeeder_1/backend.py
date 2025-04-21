import sys
import random

from PySide6.QtCore import QObject, Signal, Slot
from roboflow import Roboflow
import mysql.connector
from datetime import datetime
import base64
from PySide6.QtQml import QQmlComponent
from PySide6.QtCore import QAbstractListModel, Qt, QModelIndex, Property, Signal, Slot
from pathlib import Path
from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, QByteArray, QTimer, QCoreApplication, QProcess
import subprocess
from time import time
class AppControl(QObject):
    @Slot()
    def restart_app(self):
        print("Restarting app with delay...")

        python = sys.executable
        script = sys.argv[0]
        args = sys.argv[1:]

        # Use QTimer to allow QML signals to finish
        QTimer.singleShot(100, lambda: QProcess.startDetached(python, [script] + args))
        QTimer.singleShot(150, lambda: sys.exit(0))  # Let Qt unwind first


class BirdSighting(QObject):
    def __init__(self, name, imagePath):
        super().__init__()
        self._name = name
        self._imagePath = imagePath

    @Property(str)
    def name(self):
        return self._name

    @Property(str)
    def imagePath(self):
        return self._imagePath


class RecentSightingsModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1
    ImageRole = Qt.UserRole + 2

    def __init__(self):
        super().__init__()
        self._sightings = []
        self.fetch()  # initial load

    def rowCount(self, parent=QModelIndex()):
        return len(self._sightings)

    def data(self, index, role):
        if not index.isValid():
            return None
        sighting = self._sightings[index.row()]
        if role == self.NameRole:
            return sighting.name
        if role == self.ImageRole:
            return sighting.imagePath
        return None

    def roleNames(self):
        return {
            self.NameRole: b"name",
            self.ImageRole: b"imagePath"
        }

    @Slot()
    def fetch(self):
        print("Fetching 10 most recent sightings...")
        db = mysql.connector.connect(
            host="localhost", user="root", password="bird123", database="test"
        )
        cursor = db.cursor()
        cursor.execute("""
            SELECT name, image FROM bird_sightings
            ORDER BY time DESC LIMIT 10
        """)
        rows = cursor.fetchall()

        sightings = []
        for i, (name, image_blob) in enumerate(rows):
            image_path = f"images/recent_{i}.jpg"
            with open(image_path, "wb") as f:
                f.write(image_blob)
            unique_path = f"{image_path}?v={int(time())}"
            sightings.append(BirdSighting(name, unique_path))

        cursor.close()
        db.close()

        self.beginResetModel()
        self._sightings = sightings
        self.endResetModel()

class StatsModel(QObject):
    statsChanged = Signal()

    def __init__(self):
        super().__init__()
        self._stats = {}
        self.fetch()  # Load on creation

    @Slot()
    def fetch(self):
        print("Fetching stats...")
        self._stats = get_bird_stats()
        self.statsChanged.emit()

    @Property(int, notify=statsChanged)
    def totalBirds(self):
        return self._stats.get("totalBirds", 0)

    @Property(int, notify=statsChanged)
    def uniqueSpecies(self):
        return self._stats.get("uniqueSpecies", 0)

    @Property(str, notify=statsChanged)
    def mostFrequent(self):
        return self._stats.get("mostFrequent", "")

    @Property(str, notify=statsChanged)
    def lastSeen(self):
        return self._stats.get("lastSeen", "")

    @Property(str, notify=statsChanged)
    def lastSeenImage(self):
        return self._stats.get("lastSeenImage", "")

def get_bird_stats():
  db = mysql.connector.connect(
      host="localhost",
      user="root",
      password="bird123",
      database="test"
  )
  cursor = db.cursor()

  # Total bird sightings
  cursor.execute("SELECT COUNT(*) FROM bird_sightings")
  result = cursor.fetchone()
  total_birds = result[0] if result else 0

  # Unique species
  cursor.execute("SELECT COUNT(DISTINCT name) FROM bird_sightings")
  result = cursor.fetchone()
  unique_species = result[0] if result else 0

  # Most recent visitor
  cursor.execute("SELECT name FROM bird_sightings ORDER BY time DESC LIMIT 1")
  result = cursor.fetchone()
  recent_visitor = result[0] if result else "No sightings yet"

  # Most frequently seen species
  cursor.execute("""
      SELECT name FROM bird_sightings
      GROUP BY name
      ORDER BY COUNT(*) DESC
      LIMIT 1
  """)
  result = cursor.fetchone()
  most_frequent = result[0] if result else "No sightings yet"

  # Last seen species + image
  cursor.execute("SELECT name FROM bird_sightings ORDER BY time DESC LIMIT 1")
  result = cursor.fetchone()
  last_seen = result[0] if result else "No sightings yet"

  cursor.execute("SELECT image FROM bird_sightings ORDER BY time DESC LIMIT 1")
  result = cursor.fetchone()
  image_blob = result[0] if result else None

  image_path = "images/last_seen.jpg"

  if image_blob:
        with open(image_path, "wb") as f:
            f.write(image_blob)

        # Bust cache with timestamp
        from time import time
        image_path += f"?v={int(time())}"
  else:
      image_path = ""

  cursor.close()
  db.close()

  return {
      "totalBirds": total_birds,
      "uniqueSpecies": unique_species,
      "recentVisitor": recent_visitor,
      "mostFrequent": most_frequent,
      "lastSeen": last_seen,
      "lastSeenImage": image_path
  }




class SightingsModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1
    TimeRole = Qt.UserRole + 2
    LocationRole = Qt.UserRole + 3
    ConfidenceRole = Qt.UserRole + 4
    ImageRole = Qt.UserRole + 5

    @Slot()
    def clear_database(self):
        db_config = {
            "host": "localhost",
            "user": "root",
            "password": "bird123",
            "database": "test"
        }
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("DELETE FROM bird_sightings")
        conn.commit()
        cursor.close()
        conn.close()

        print("Database cleared")
        self.fetch_sightings()  # refresh the list in QML

    def __init__(self, parent=None):
        super().__init__(parent)
        self._data = []

    def rowCount(self, parent=QModelIndex()):
        return len(self._data)

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid():
            return None
        row = self._data[index.row()]
        if role == self.NameRole:
            return row["name"]
        elif role == self.TimeRole:
            return row["time"]
        elif role == self.LocationRole:
            return row["location"]
        elif role == self.ConfidenceRole:
            return row["confidence_percentage"]
        elif role == self.ImageRole:
            return row["image"]
        return None

    def roleNames(self):
        return {
            self.NameRole: b"name",
            self.TimeRole: b"time",
            self.LocationRole: b"location",
            self.ConfidenceRole: b"confidence_percentage",
            self.ImageRole: b"image"
        }

    @Slot()
    def fetch_sightings(self):
        db_config = {
            "host": "localhost",
            "user": "root",
            "password": "bird123",
            "database": "test"
        }
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()

        query = "SELECT name, time, location, confidence_percentage, image FROM bird_sightings ORDER BY time DESC"
        cursor.execute(query)

        self.beginResetModel()
        self._data = []
        for name, time, location, confidence, image_blob in cursor:
            if image_blob:
                base64_img = base64.b64encode(image_blob).decode('utf-8')
                image_url = f"data:image/jpeg;base64,{base64_img}"
            else:
                image_url = ""
            self._data.append({
                "name": name,
                "time": str(time),
                "location": location,
                "confidence_percentage": str(confidence),
                "image": image_url
            })
        self.endResetModel()

        cursor.close()
        conn.close()




class PythonBackend(QObject):

    databaseUpdated = Signal(list)

    imageUpdated = Signal(str, str, float)  # Signal with image path, prediction, confidence

    def __init__(self):
        super().__init__()
        self.rf = Roboflow(api_key="5HCjSD7r7g2tqXtSHPXA")  # Roboflow API Key
        self.project = self.rf.workspace().project("bird-v2")  # Load Project
        self.model = self.project.version(2).model  # Load model version



    @Slot(result=dict)
    def listBirdImages(self):
      try:
          bird_folder = Path("BirdImages")
          image_files = list(bird_folder.glob("*.*"))
          if not image_files:
              print("No images found in BirdImages folder.")
              return {"path": "", "timestamp": ""}
          selected_image = random.choice(image_files)
          timestamp = datetime.now().strftime("%H:%M:%S")
          return {"path": str(selected_image), "timestamp": timestamp}
      except Exception as e:
          print(f"Error listing bird images: {e}")
          return {"path": "", "timestamp": ""}



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
        self.storeToDatabase(prediction, confidence, "Cincinnati", image_path)



    def storeToDatabase(self, name, confidence, location, image_path):
        try:
            # Connect to MySQL
            conn = mysql.connector.connect(
                host="localhost",
                user="root",
                password="bird123",
                database="test"
            )
            cursor = conn.cursor()

            # Read image in binary mode
            with open(image_path, 'rb') as file:
                image_blob = file.read()

            # Current time
            current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

            # SQL Insert
            insert_query = """
            INSERT INTO bird_sightings (name, time, location, confidence_percentage, image)
            VALUES (%s, %s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE
                time = VALUES(time),
                location = VALUES(location),
                confidence_percentage = VALUES(confidence_percentage),
                image = VALUES(image);
            """

            cursor.execute(insert_query, (name, current_time, location, confidence, image_blob))
            conn.commit()
            print(f"Data for '{name}' inserted into database.")

        except Exception as e:
            print(f"Error inserting into database: {e}")
        finally:
            cursor.close()
            conn.close()

if __name__ == "__main__":
    from PySide6.QtWidgets import QApplication
    from PySide6.QtQml import QQmlApplicationEngine

    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    backend = PythonBackend()
    engine.rootContext().setContextProperty("pythonInterface", backend)

    engine.load("CameraWindow.qml")
    engine.load("DetailsWindow.qml")

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
