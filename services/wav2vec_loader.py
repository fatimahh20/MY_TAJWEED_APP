import torch
import librosa
from transformers import Wav2Vec2Processor, Wav2Vec2ForCTC

MODEL_ID = "jonatasgrosman/wav2vec2-large-xlsr-53-arabic"

print("⏳ Loading wav2vec2 model...")

processor = Wav2Vec2Processor.from_pretrained(MODEL_ID)
model = Wav2Vec2ForCTC.from_pretrained(MODEL_ID)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model.to(device)
model.eval()

print("✅ Model loaded")
