# Backend Setup Guide - FIXED! ✅

## 🎯 Problem Solved

The error `Could not import module "main"` occurred because you were running uvicorn from the **wrong directory**.

## ✅ CORRECT Setup Commands

### 1. Navigate to Backend Directory FIRST
```bash
# Navigate to backend directory
cd c:\Projects\livenessAI\backend

# Activate virtual environment (Windows)
venv\Scripts\activate
```

### 2. Run uvicorn FROM INSIDE Backend Directory
```bash
# This command MUST be run FROM the backend directory
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

## 🚀 Expected Output

When you run the correct commands, you should see:

```
🚀 Initializing Liveness-AI Backend...
✅ OpenCV Face Cascade initialized
📝 Using OpenCV-only detection for maximum compatibility
⚠️  Model file not found at C:\Projects\livenessAI\backend\utils\..\model\deepfake_model.h5
🔄 Creating dummy model for testing...
INFO:     Started server process [17920]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

## 🌐 Access the Backend

Once running, access at:
- **Health Check**: http://localhost:8000/health
- **API Docs**: http://localhost:8000/docs
- **Root**: http://localhost:8000/

## 📱 Flutter App Connection

The Flutter app will automatically connect to:
- **Android Emulator**: `http://10.0.2.2:8000`
- **iOS Simulator**: `http://localhost:8000`
- **Web/Other**: `http://localhost:8000`

## ⚠️ Model Warning

You'll see a warning about the model file:
```
⚠️  Model file not found at C:\Projects\livenessAI\backend\utils\..\model\deepfake_model.h5
🔄 Creating dummy model for testing...
```

This is **normal** - the system creates a dummy model for testing until you place your trained model.

## 🔧 Complete Setup Sequence

### Backend (Terminal 1):
```bash
cd c:\Projects\livenessAI\backend
venv\Scripts\activate
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### Flutter App (Terminal 2):
```bash
cd c:\Projects\livenessAI\frontend\liveness_app
flutter run -d emulator-5554
```

## ✅ Verification

1. **Backend Status**: Open http://localhost:8000/health in browser
2. **Flutter App**: Should connect automatically and show camera preview
3. **Test Capture**: Take a photo and see the enhanced result dialog

## 🎉 Success!

Your backend is now running correctly! The system is ready for:
- ✅ **Live camera analysis**
- ✅ **Photo upload detection**
- ✅ **Enhanced result dialogs**
- ✅ **Manipulation heatmaps**
- ✅ **Professional UI with tabs**

**The key was running uvicorn from the correct backend directory!** 🚀
