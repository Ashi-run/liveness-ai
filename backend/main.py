import cv2
import numpy as np
import tensorflow as tf
import mediapipe as mp
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import io
from PIL import Image
import os
import sys

# Add utils to path
sys.path.append(os.path.join(os.path.dirname(__file__), 'utils'))
from face_detector import FaceDetector
from inference import LivenessInference

app = FastAPI(
    title="Liveness-AI Backend",
    description="Deepfake + Face Liveness Detection API",
    version="1.0.0"
)

# Enable CORS for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize components
print("🚀 Initializing Liveness-AI Backend...")
face_detector = FaceDetector()
inference_engine = LivenessInference()

@app.get("/")
async def root():
    """Health check endpoint"""
    return {
        "status": "Liveness-AI Backend Running",
        "version": "1.0.0",
        "endpoints": {
            "predict": "/predict",
            "health": "/"
        }
    }

@app.post("/predict")
async def predict_liveness(file: UploadFile = File(...)):
    """
    Predict liveness from uploaded image
    
    Args:
        file: Image file (multipart/form-data)
        
    Returns:
        JSON response with status and confidence
    """
    try:
        # Validate file type
        if not file.content_type.startswith('image/'):
            raise HTTPException(status_code=400, detail="File must be an image")
        
        # 1. Read and process image
        contents = await file.read()
        image = Image.open(io.BytesIO(contents)).convert('RGB')
        img_array = np.array(image)
        
        # Convert RGB to BGR for OpenCV processing
        if len(img_array.shape) == 3:
            img_bgr = cv2.cvtColor(img_array, cv2.COLOR_RGB2BGR)
        else:
            img_bgr = img_array
        
        # 2. ACTIVE LAYER: Mediapipe 3D Depth Check
        mesh_results = face_detector.detect_face_mesh(img_array)
        if mesh_results is None or not mesh_results.multi_face_landmarks:
            # If MediaPipe fails, continue with OpenCV only
            print("⚠️  MediaPipe detection failed, using OpenCV only")
        else:
            # Check for spoof using depth analysis
            landmarks = mesh_results.multi_face_landmarks[0]
            is_depth_spoof = face_detector.is_spoof_by_depth(landmarks)
            
            if is_depth_spoof:
                return {
                    "status": "FAKE", 
                    "confidence": 0.99,
                    "reason": "Flat 3D depth detected - possible photo spoof"
                }
        
        # 3. PASSIVE LAYER: Face Detection and Cropping
        face_crop, bbox = face_detector.detect_and_crop_face(img_bgr)
        if face_crop is None:
            return {
                "status": "NO_FACE_DETECTED", 
                "confidence": 0.0,
                "reason": "No face detected with OpenCV"
            }
        
        # 4. DEEP LEARNING LAYER: Texture Analysis
        prediction_score = inference_engine.predict(face_crop)
        
        # Convert prediction to status and confidence
        if prediction_score < 0.5:
            status = "REAL"
            confidence = float(1.0 - prediction_score)
        else:
            status = "FAKE"
            confidence = float(prediction_score)
        
        return {
            "status": status,
            "confidence": round(confidence, 3),
            "raw_score": round(prediction_score, 3),
            "face_detected": True,
            "bbox": bbox
        }
        
    except HTTPException:
        raise
    except Exception as e:
        print(f"❌ Prediction error: {e}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")

@app.get("/health")
async def health_check():
    """Detailed health check"""
    return {
        "status": "healthy",
        "components": {
            "face_detector": "operational",
            "inference_engine": "operational" if inference_engine.model else "model_not_loaded",
            "model_path": inference_engine.model_path
        }
    }

if __name__ == "__main__":
    import uvicorn
    print("🌐 Starting Liveness-AI Backend Server...")
    print("📡 API will be available at: http://localhost:8000")
    print("📖 API docs at: http://localhost:8000/docs")
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)