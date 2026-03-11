import cv2
import numpy as np
import tensorflow as tf

print("Waking up the Liveness-AI model...")
model = tf.keras.models.load_model('LivenessModel.h5')

# 1. Load OpenCV's built-in Face Detector
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

print("Model loaded successfully! Opening webcam...")
cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # 2. Convert frame to grayscale (required for the face detector to work)
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    
    # 3. Detect faces in the frame
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(100, 100))

    # 4. Loop through any faces found
    for (x, y, w, h) in faces:
        # Crop the frame to just the face bounding box
        face_crop = frame[y:y+h, x:x+w]
        
        # Preprocess ONLY the cropped face for the model
        resized_face = cv2.resize(face_crop, (224, 224))
        input_array = np.expand_dims(resized_face, axis=0)
        
        # Make the prediction on the cropped face
        prediction = model.predict(input_array, verbose=0)[0][0]

        # Determine label
        if prediction < 0.5:
            confidence = (1.0 - prediction) * 100
            label = f"REAL ({confidence:.1f}%)"
            color = (0, 255, 0) # Green
        else:
            confidence = prediction * 100
            label = f"SPOOF ({confidence:.1f}%)"
            color = (0, 0, 255) # Red

        # Draw a rectangle exactly around the detected face
        cv2.rectangle(frame, (x, y), (x+w, y+h), color, 2)
        # Put the text right above the face box
        cv2.putText(frame, label, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.8, color, 2)

    cv2.imshow('Liveness-AI Prototype Test (Cropped)', frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()