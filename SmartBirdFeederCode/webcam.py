import cv2
from PySide6.QtCore import Signal, QObject
from PySide6.QtGui import QImage

class WebcamHandler(QObject):
    frame_signal = Signal(object)  # Signal to send the frame to QML

    def __init__(self):
        super().__init__()
        self.capture = None

    def start_webcam(self):
        print("Start Webcam called!")  # Debugging line to check if function is triggered
        self.capture = cv2.VideoCapture(0)

        if not self.capture.isOpened():
            print("Error: Could not open webcam.")
            return

        # Process the frames here, for example by emitting the frame signal
        while True:
            ret, frame = self.capture.read()
            if not ret:
                print("Error: Failed to grab frame.")
                break

            # Convert the frame to QImage and emit the signal
            frame_qt = self.convert_to_qimage(frame)
            self.frame_signal.emit(frame_qt)

    def stop_webcam(self):
        if self.capture is not None:
            print("Stop Webcam called!")  # Debugging line
            self.capture.release()
            self.capture = None

    def convert_to_qimage(self, frame):
        # Convert the OpenCV frame to QImage
        height, width, channel = frame.shape
        bytes_per_line = 3 * width
        qimg = QImage(frame.data, width, height, bytes_per_line, QImage.Format_RGB888)
        return qimg
