import librosa
import torch
from wav2vec_loader import processor, model, device

def decode_audio(audio_path):
    speech, sr = librosa.load(audio_path, sr=16000)
    inputs = processor(
        speech,
        sampling_rate=16000,
        return_tensors="pt",
        padding=True
    )

    with torch.no_grad():
        logits = model(inputs.input_values.to(device)).logits

    predicted_ids = torch.argmax(logits, dim=-1)
    transcription = processor.batch_decode(predicted_ids)[0]

    return transcription.strip()

def normalize_arabic(text):
    tashkeel = "ًٌٍَُِّْ"
    text = "".join(ch for ch in text if ch not in tashkeel)
    return text.replace(" ", "")
