from fastapi import APIRouter, UploadFile, File
import shutil, os
import librosa
import torch

from services.wav2vec_loader import processor, model, device
from services.metadata_loader import df

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)



@router.post("/upload-audio")
async def upload_audio(file: UploadFile = File(...)):
    ...
    transcription = processor.batch_decode(predicted_ids)[0].strip()

    print("🧠 Transcription:", transcription)

    # BASIC matching (no tashkeel handling yet)
    row = df[df["word"] == transcription]

    if row.empty:
        return {
            "transcription": transcription,
            "matched": False
        }

    ref_phonemes = row.iloc[0]["phenome"]

    return {
        "transcription": transcription,
        "matched": True,
        "reference_phonemes": ref_phonemes
    }

