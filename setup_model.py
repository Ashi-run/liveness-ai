import tensorflow as tf
from tensorflow.keras.applications import MobileNetV2

# Instantiate the base MobileNetV2 model
base_model = MobileNetV2(
    include_top=False,
    input_shape=(224, 224, 3)
)

print("MobileNetV2 base model created successfully!")
print(f"Model input shape: {base_model.input_shape}")
print(f"Model output shape: {base_model.output_shape}")
