# LivenessAI - Deepfake + Face Liveness Detection System

A production-ready face liveness detection system combining computer vision, deep learning, and modern mobile UI to detect deepfakes and spoof attempts in real-time.

## 🎯 Project Overview

LivenessAI is a comprehensive system that detects whether a face in an image or video stream is **REAL** or **FAKE** using multiple layers of analysis:

### 🔍 Detection Layers
1. **Active Layer**: 3D depth analysis using MediaPipe FaceMesh
2. **Passive Layer**: OpenCV face detection and cropping
3. **Deep Learning Layer**: TensorFlow model for texture analysis

### 📱 Features
- **Real-time camera preview** with live confidence scoring
- **Modern animated UI** with glassmorphism effects
- **Photo upload** option for gallery images
- **Live confidence charts** showing liveness scores over time
- **Cross-platform** Flutter frontend (Android/iOS)
- **RESTful API** backend with FastAPI

---

## 🏗️ Project Structure

```
LivenessAI/
│
├── backend/                    # Python FastAPI Backend
│   ├── main.py                # FastAPI application with endpoints
│   ├── requirements.txt         # Python dependencies
│   ├── venv/                 # Virtual environment
│   ├── model/                 # Model storage
│   │   └── deepfake_model.h5 # TensorFlow model (place your model here)
│   └── utils/                 # Backend utilities
│       ├── face_detector.py     # Face detection and cropping
│       └── inference.py        # TensorFlow inference engine
│
├── frontend/                   # Flutter Mobile App
│   └── liveness_app/
│       ├── lib/
│       │   ├── main.dart       # Main application
│       │   └── services/
│       │       └── api_service.dart # HTTP API client
│       ├── android/app/src/main/AndroidManifest.xml
│       └── pubspec.yaml       # Flutter dependencies
│
└── README.md                  # This file
```

---

## 🚀 Quick Start

### Prerequisites
- **Python 3.8+** for backend
- **Flutter SDK** for frontend
- **Android Studio** or **VS Code** with Flutter extensions
- **Android Emulator** or physical device

### Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Create and activate virtual environment:**
   ```bash
   # Windows
   python -m venv venv
   venv\Scripts\activate
   
   # Mac/Linux
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Place your model:**
   - Add your trained TensorFlow model to `backend/model/deepfake_model.h5`
   - If no model is provided, a dummy model will be created for testing

5. **Start the server:**
   ```bash
   uvicorn main:app --host 0.0.0.0 --port 8000 --reload
   ```

6. **Verify backend is running:**
   - Open `http://localhost:8000` in browser
   - Check `http://localhost:8000/docs` for API documentation

### Frontend Setup

1. **Navigate to Flutter app:**
   ```bash
   cd frontend/liveness_app
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   # For Android emulator
   flutter run
   
   # For specific device
   flutter run -d <device_id>
   
   # List available devices
   flutter devices
   ```

4. **Grant permissions:**
   - Camera permission when prompted
   - Storage permission for photo upload

---

## 📡 API Documentation

### Endpoints

#### `GET /`
Health check endpoint
```json
{
  "status": "Liveness-AI Backend Running",
  "version": "1.0.0",
  "endpoints": {
    "predict": "/predict",
    "health": "/"
  }
}
```

#### `GET /health`
Detailed health check
```json
{
  "status": "healthy",
  "components": {
    "face_detector": "operational",
    "inference_engine": "operational",
    "model_path": "backend/model/deepfake_model.h5"
  }
}
```

#### `POST /predict`
Main prediction endpoint
- **Content-Type**: `multipart/form-data`
- **Field**: `image` (file)

**Response:**
```json
{
  "status": "REAL",
  "confidence": 0.87,
  "raw_score": 0.13,
  "face_detected": true,
  "bbox": [x, y, width, height]
}
```

**Status Values:**
- `"REAL"`: Face is authentic
- `"FAKE"`: Deepfake/spoof detected
- `"NO_FACE_DETECTED"`: No face found in image

---

## 🎨 UI Features

### Splash Screen
- Animated LIVENESS-AI logo with glowing effects
- 3-second duration with smooth transitions
- Dark theme with gradient background

### Main Screen
- **Circular camera preview** with neon blue border
- **Real-time confidence chart** using fl_chart
- **Two action buttons**:
  - "Verify Liveness" - Capture from camera
  - "Upload Photo" - Select from gallery

### Result Dialogs
- **Green success** for REAL faces
- **Red warning** for FAKE/spoof detection
- Confidence percentage display
- Smooth animations and transitions

---

## 🔧 Configuration

### Backend Configuration

Edit `backend/main.py` to customize:
- **Model path**: Change `model_path` in `LivenessInference`
- **Confidence threshold**: Adjust prediction logic
- **CORS settings**: Modify `allow_origins` for production

### Frontend Configuration

Edit `frontend/liveness_app/lib/services/api_service.dart`:
- **API URL**: Change `baseUrl` for different server
- **Timeout settings**: Add request timeout configurations

---

## 🧪 Testing

### Backend Testing
```bash
# Test health endpoint
curl http://localhost:8000/health

# Test prediction with image
curl -X POST -F "image=@test_image.jpg" http://localhost:8000/predict
```

### Frontend Testing
- Use Android emulator for camera testing
- Test with real photos and deepfake images
- Verify confidence chart updates
- Test error handling (no face, server offline)

---

## 🐛 Troubleshooting

### Common Issues

**Backend:**
- **ModuleNotFoundError**: Ensure virtual environment is activated
- **Model not found**: Place `deepfake_model.h5` in `backend/model/`
- **Port already in use**: Change port in uvicorn command

**Frontend:**
- **Camera permission denied**: Grant camera permission in settings
- **Connection refused**: Ensure backend is running on correct IP
- **Emulator camera**: Use physical device for better camera testing

### Debug Mode

**Backend:**
```bash
# Run with debug logging
uvicorn main:app --host 0.0.0.0 --port 8000 --reload --log-level debug
```

**Frontend:**
```bash
# Run with debug logs
flutter run --debug
```

---

## 📦 Dependencies

### Backend
```
fastapi>=0.135.1
uvicorn>=0.41.0
opencv-python>=4.13.0
mediapipe>=0.10.32
python-multipart>=0.0.22
tensorflow>=2.21.0
numpy>=2.4.3
pillow>=12.1.1
```

### Frontend
```
flutter>=3.10.7
camera: ^0.10.5+5
image_picker: ^1.0.4
http: ^1.1.0
fl_chart: ^0.65.0
flutter_animate: ^4.2.0+1
permission_handler: ^11.0.1
```

---

## 🔒 Security Considerations

- **HTTPS**: Use HTTPS in production
- **Input validation**: All inputs are validated
- **Rate limiting**: Implement rate limiting for production
- **CORS**: Configure proper origins for production
- **Model security**: Protect model file access

---

## 🚀 Deployment

### Backend Deployment
1. **Dockerize** the FastAPI application
2. **Use Gunicorn** for production WSGI server
3. **Configure Nginx** as reverse proxy
4. **Set up SSL** certificates

### Frontend Deployment
1. **Build APK**: `flutter build apk`
2. **Build App Bundle**: `flutter build appbundle`
3. **Deploy to Play Store** or distribute directly

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -m 'Add feature'`
4. Push to branch: `git push origin feature-name`
5. Submit pull request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👥 Team

- **Backend Developer**: Python/FastAPI specialist
- **Frontend Developer**: Flutter/Dart expert  
- **ML Engineer**: TensorFlow/Computer Vision
- **UI/UX Designer**: Modern interface design

---

## 📞 Support

For issues and questions:
- Create GitHub issue with detailed description
- Include error logs and screenshots
- Specify platform (Android/iOS) and Flutter version

---

**🎉 Thank you for using LivenessAI!**

*Built with ❤️ using Python, TensorFlow, Flutter, and modern UI design principles.*
