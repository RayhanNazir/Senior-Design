
# 🐦 Smart Bird Feeder App — User Manual

### Version: 1.0  
### Framework: Qt 6.8 (PySide6)  
### Author: *[Your Name]*  
### Last Updated: *[Date]*

---

## 📋 Overview

The **Smart Bird Feeder App** is an intelligent system designed to identify, log, and display bird sightings using computer vision and a MySQL database. This app is split into a camera interface for capturing images and a dashboard for reviewing sighting data and statistics.

It integrates with the Roboflow bird classification model and supports real-time UI updates via QML.

---

## 🚀 Getting Started

### Requirements

- Python 3.10+  
- MySQL Server  
- PySide6 (`pip install pyside6`)  
- Roboflow API key  
- QML/Qt 6.8 environment  
- MySQL table: `bird_sightings(name, time, location, confidence_percentage, image)`

### File Structure

```
SmartBirdFeeder/
├── main.py                # Entry point
├── backend.py             # Database and model logic
├── main.qml               # Main UI layout
├── CameraWindow.qml       # Camera capture interface
├── DetailsWindow.qml      # Sightings details view
├── images/                # Saves prediction and thumbnail images
├── src/camera_handler.py  # Hardware control for camera
```

---

## 🖥️ How to Run

1. Ensure MySQL server is running and contains the `bird_sightings` table.
2. Set your Roboflow API key in `PythonBackend`.
3. Activate virtual environment (optional).
4. Launch the app:
```bash
python main.py
```
5. The main interface (`main.qml`) will load and initialize.

---

## 📦 Features

### 📸 Camera Integration
- Use the camera to take bird pictures.
- Process images through Roboflow's model to classify birds.
- Save predictions, confidence scores, and annotated images to the database.

### 📊 Stats Dashboard (`main.qml`)
Displays:
- Total bird sightings  
- Unique species count  
- Most frequently seen bird  
- Last bird seen with image  

### 🐦 Sightings Viewer (`DetailsWindow.qml`)
- View all sightings in a scrollable list.
- Each sighting shows name, time, location, confidence %, and image.

### 🔁 Refresh & Update Support
- Refresh recent sightings and stats with a button.
- Data is auto-updated after new sightings.

### 🧹 Clear Database
The `SightingsModel` provides a slot to clear the database:
```python
sightingsModel.clear_database()
```

---

## 🛠️ Developer Notes

- `PythonBackend` handles Roboflow image processing and database insertion.
- `StatsModel`, `SightingsModel`, and `RecentSightingsModel` are exposed to QML and update the UI.
- QML views call `model.fetch()` methods to trigger updates.

---

## ❓ Troubleshooting

| Problem | Solution |
|---------|----------|
| App won't launch | Check QML syntax in `main.qml`, ensure MySQL is running |
| Image not updating | Ensure image blobs are valid and `image_path += '?v='` is used to bypass caching |
| No camera preview | Verify that the camera is properly handled in `CameraHandler` |
| Roboflow errors | Ensure API key and model ID in `backend.py` are valid |

---

## 🧪 Future Enhancements

- Add user authentication
- Export sightings to CSV or JSON
- Filter sightings by time, species, or location
- Real-time camera stream preview

---

## 📞 Contact

For bugs, suggestions, or contributions, please contact:

📧 *youremail@example.com*  
🔗 *github.com/yourrepo*

---
