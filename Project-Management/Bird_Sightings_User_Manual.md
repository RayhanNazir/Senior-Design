
# 🐦 Bird Sightings Viewer — User Manual

### Version: 1.0  
### Platform: Qt 6.8 with PySide6  
### Author: *[Your Name]*  
### Last Updated: *[Date]*

---

## 📋 Overview

The **Bird Sightings Viewer** is a desktop application that displays a list of recorded bird sightings stored in a MySQL database. It showcases bird name, time, location, confidence level, and an optional image in a clean, scrollable UI.

This app is designed for bird watchers, researchers, or anyone interested in managing and reviewing bird data in real-time.

---

## 🚀 Getting Started

### Prerequisites

- Python 3.10+  
- PySide6 (`pip install pyside6`)  
- MySQL Server (with bird sighting data loaded)  
- Access credentials to the database (update in the Python backend)

### File Structure

```
SmartBirdFeeder/
├── main.py             # Application entry point
├── backend.py          # Python model connected to MySQL
├── main.qml            # Frontend UI in QML
└── README.md / this_manual.md
```

---

## 🖥️ Launching the App

1. Activate your Python virtual environment (if applicable):
   ```bash
   source venv/bin/activate   # Mac/Linux
   .\.venv\Scripts\activate   # Windows
   ```

2. Run the app:
   ```bash
   python main.py
   ```

3. The main window will appear, and data from the MySQL database will be loaded automatically.

---

## 📦 Features

### 🐤 Display Sightings

Each sighting displays:
- **Name** of the bird  
- **Timestamp** of the sighting  
- **Location** where the bird was observed  
- **Confidence %** from the classifier  
- **Image**, if available (displayed with rounded corners)

### 🔁 Refresh Sightings

- Click the **"Refresh"** button in the top section (if included), or
- Wait for **automatic updates** (if using a `Timer`), or
- Trigger a refresh from the backend (e.g., after inserting a new bird sighting)

### 💾 Live Database Integration

The app reads directly from a MySQL table:
```sql
bird_sightings(name, time, location, confidence_percentage, image)
```

Ensure this schema is populated in your database.

---

## 🛠️ Developer Controls

### Modifying the Database

Edit the `fetch_sightings` method in `backend.py` if your schema changes.

### Styling & Layout

Update `main.qml` to:
- Customize layouts
- Add filters or a search bar
- Change fonts, spacing, or themes

---

## ❓ Troubleshooting

| Issue | Solution |
|-------|----------|
| `Invalid property name "radius"` | Wrap `Image` in `Rectangle` with `clip: true` |
| App doesn't open | Check that `main.qml` is loaded in `main.py` |
| No data shown | Ensure your MySQL server is running and has valid records |
| Image not loading | Ensure BLOB field contains valid JPEG/PNG data and is converted to base64 |

---

## ✨ Future Improvements (Optional)

- Add detail view on sighting click  
- Add bird search or filtering  
- Export sightings to CSV or PDF  
- Add authentication and role-based access  

---

## 📞 Contact / Support

For support or collaboration requests, please contact:

📧 *youremail@example.com*  
🔗 *github.com/yourrepo*
