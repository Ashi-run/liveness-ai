import cv2
import numpy as np

class FaceDetector:
    def __init__(self):
        # OpenCV Face Cascade for detection and cropping
        self.face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
        print("✅ OpenCV Face Cascade initialized")
        print("📝 Using OpenCV-only detection for maximum compatibility")
    
    def detect_face_mesh(self, image: np.ndarray):
        """Placeholder for MediaPipe compatibility - returns None"""
        return None
    
    def get_face_depth(self, landmarks):
        """Placeholder for depth analysis - returns None"""
        return None
    
    def is_spoof_by_depth(self, landmarks, threshold: float = 0.001):
        """Placeholder for depth-based spoof detection - always returns False"""
        return False
    
    def detect_and_crop_face(self, image: np.ndarray):
        """Detect face using OpenCV and crop to face region"""
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY) if len(image.shape) == 3 else image
        faces = self.face_cascade.detectMultiScale(gray, 1.1, 4)
        
        if len(faces) == 0:
            return None, None
        
        # Get the first face detected
        x, y, w, h = faces[0]
        face_crop = image[y:y+h, x:x+w]
        
        return face_crop, (x, y, w, h)
