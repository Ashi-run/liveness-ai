import tensorflow as tf
import cv2
import numpy as np
import os

class LivenessInference:
    def __init__(self, model_path: str = None):
        self.model = None
        self.model_path = model_path or os.path.join(os.path.dirname(__file__), '..', 'model', 'deepfake_model.h5')
        self.load_model()
    
    def load_model(self):
        """Load the TensorFlow model"""
        try:
            if os.path.exists(self.model_path):
                self.model = tf.keras.models.load_model(self.model_path)
                print(f"✅ Model loaded successfully from {self.model_path}")
            else:
                print(f"⚠️  Model file not found at {self.model_path}")
                print("   Please place your deepfake_model.h5 file in the backend/model/ directory")
                # Create a dummy model for testing
                self.model = self._create_dummy_model()
        except Exception as e:
            print(f"❌ Error loading model: {e}")
            self.model = self._create_dummy_model()
    
    def _create_dummy_model(self):
        """Create a simple dummy model for testing when real model is not available"""
        print("🔄 Creating dummy model for testing...")
        model = tf.keras.Sequential([
            tf.keras.layers.Input(shape=(224, 224, 3)),
            tf.keras.layers.GlobalAveragePooling2D(),
            tf.keras.layers.Dense(1, activation='sigmoid')
        ])
        model.compile(optimizer='adam', loss='binary_crossentropy')
        return model
    
    def preprocess_image(self, image: np.ndarray):
        """Preprocess image for model inference"""
        # Resize to 224x224 (standard for most models)
        resized = cv2.resize(image, (224, 224))
        
        # Convert RGB if needed
        if len(resized.shape) == 3 and resized.shape[2] == 3:
            # Assume BGR (OpenCV default), convert to RGB
            rgb_image = cv2.cvtColor(resized, cv2.COLOR_BGR2RGB)
        else:
            rgb_image = resized
        
        # Add batch dimension
        input_array = np.expand_dims(rgb_image, axis=0)
        
        # Normalize based on model type (Xception preprocessing)
        try:
            input_array = tf.keras.applications.xception.preprocess_input(input_array)
        except:
            # Fallback to simple normalization
            input_array = input_array / 255.0
        
        return input_array
    
    def predict(self, image: np.ndarray):
        """Run inference on preprocessed image"""
        if self.model is None:
            return 0.5  # Neutral prediction if no model
        
        try:
            processed_image = self.preprocess_image(image)
            prediction = self.model.predict(processed_image)[0][0]
            return float(prediction)
        except Exception as e:
            print(f"❌ Inference error: {e}")
            return 0.5  # Neutral prediction on error
