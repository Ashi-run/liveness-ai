# Android Emulator Setup Guide for LivenessAI

## 🎯 Problem Solved

The issues you encountered have been fixed:

✅ **Widget Test Fixed**: `widget_test.dart` now uses correct `LivenessAIApp` widget  
✅ **API Integration Fixed**: Backend communication now works across platforms  
✅ **Camera Permissions Added**: App requests camera permission properly  
✅ **Web Compatibility**: App works on Android emulator, not just Chrome  
✅ **Enhanced UI**: Professional interface with all requested features  

---

## 📱 Android Emulator Setup Instructions

### 1. Install Android Emulator
```bash
# In Android Studio
Tools -> AVD Manager -> Create Virtual Device
# Select:
# - Device: Pixel 6 (API Level 33)
# - RAM: 4096 MB or higher
# - Internal Storage: 2 GB
# - Graphics: Hardware - GLES 3.0
```

### 2. Start Emulator
```bash
# Start the emulator
emulator -avd Pixel_6_API_33

# Or use Android Studio's device manager
# Click the play button next to your device
```

### 3. Run Flutter App on Emulator
```bash
# Navigate to Flutter project
cd frontend/liveness_app

# Check connected devices
flutter devices

# Run on specific emulator
flutter run -d emulator-5554

# Or run on all available devices
flutter run
```

### 4. Grant Camera Permissions
When the app starts, it will automatically:
- Request camera permission
- Show permission dialog if denied
- Guide user to settings if needed

### 5. Test Camera Functionality
The app now includes:
- ✅ **Live camera preview** with neon blue border
- ✅ **Real-time confidence chart** 
- ✅ **Capture and analyze** functionality
- ✅ **Gallery upload** option
- ✅ **Tab-based interface** (Camera, Gallery, History)
- ✅ **Dark/Light theme toggle**
- ✅ **Professional result dialogs** with detailed analysis

---

## 🔧 Backend Setup

### 1. Start Backend Server
```bash
# Navigate to backend
cd backend

# Activate virtual environment (Windows)
venv\Scripts\activate

# Start the server
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### 2. Verify Backend is Running
Open your browser and navigate to:
- **Health Check**: http://localhost:8000/health
- **API Documentation**: http://localhost:8000/docs

### 3. Test API Endpoint
```bash
# Test with sample image
curl -X POST -F "image=@test_image.jpg" http://localhost:8000/predict
```

---

## 🎨 New Features Implemented

### 1. **Enhanced Result Dialogs**
- **Authenticity Score**: Shows percentage with "Likely Real/Fake" text
- **AI Analysis Details**: Explains WHY the system thinks image is fake/real
- **Visual Indicators**: Color-coded results (green for real, red for fake)

### 2. **Manipulation Heatmap**
- **Visual Analysis**: Shows suspicious regions with confidence percentages
- **Interactive Elements**: Different colors for different manipulation types
- **Detailed Breakdown**: Explains what was detected in each area

### 3. **Tab-Based Interface**
- **Camera Tab**: Live camera with real-time analysis
- **Gallery Tab**: Upload photos from device gallery  
- **History Tab**: View previous detection results
- **Smart Tabs**: Animated transitions and selection indicators

### 4. **Professional UI Design**
- **Dark/Light Mode**: Toggle in app bar
- **Glassmorphism Effects**: Translucent backgrounds with blur
- **Neon Blue Accents**: Consistent color scheme
- **Smooth Animations**: Using flutter_animate package
- **Responsive Design**: Works on different screen sizes

---

## 🚀 Quick Start Commands

### Backend Server
```bash
cd backend
venv\Scripts\activate
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### Flutter App (Android Emulator)
```bash
cd frontend/liveness_app
flutter run -d emulator-5554
```

### Flutter App (Physical Device)
```bash
cd frontend/liveness_app
flutter devices
flutter run -d <your_device_id>
```

---

## 🐛 Troubleshooting

### Camera Not Working on Emulator
1. **Check Emulator Settings**: Ensure camera is enabled in AVD configuration
2. **Restart Emulator**: Sometimes a fresh restart fixes camera issues
3. **Use Physical Device**: For best camera performance, test on real phone

### Backend Connection Issues
1. **Check IP Address**: Ensure using `10.0.2.2:8000` for emulator
2. **Firewall**: Make sure port 8000 isn't blocked
3. **Backend Running**: Verify backend server is actually running

### Permission Issues
1. **Manual Grant**: Settings → Apps → LivenessAI → Permissions → Camera
2. **Restart App**: After granting permissions, restart the app

---

## 📱 Expected Behavior

When everything is working correctly:

1. **App launches** with animated LIVENESS-AI splash screen
2. **Camera permission** dialog appears on first launch
3. **Main screen** shows with camera preview and confidence chart
4. **Camera capture** sends image to backend for analysis
5. **Enhanced dialog** appears with detailed results and explanations
6. **Heatmap** shows for fake detections with visual analysis
7. **History tab** stores all previous detection results
8. **Theme toggle** switches between dark and light modes

Your LivenessAI system is now **production-ready** with all the features you requested! 🎉
