from fastapi import FastAPI, UploadFile, File, Query, HTTPException
import pandas as pd
import os
import shutil

from utils.audio_handler import get_tajweed_analysis
from utils.alignment import processor

app = FastAPI(title="Tajweed AI Backend")

@app.get("/")
def home():
    return {"message": "Tajweed AI Backend is running successfully 🚀"}

# Load Metadata
df = pd.read_excel("data/metadata.xlsm", engine="openpyxl")
df.columns = df.columns.str.lower()


@app.post("/upload-audio")
async def analyze_tajweed(
    word_id: str = Query(...),
    file: UploadFile = File(...)
):
    temp_path = f"uploads/{file.filename}"
    os.makedirs("uploads", exist_ok=True)

    with open(temp_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    try:
        res = df[df["id"] == word_id.strip()]
        if res.empty:
            raise HTTPException(status_code=404, detail=f"Word ID '{word_id}' not found")

        row = res.iloc[0]

        accuracy, expected, detected, fb_phoneme, fb_rule = get_tajweed_analysis(
            temp_path, row, processor
        )

        status_text = "MUMTAZ" if accuracy >= 80 else "Do More Practise"

        return {
            "status": status_text,
            "tajweed_report": {
                "word": row["word"],
                "rule": str(row["rule"]).strip(),
                "accuracy": f"{accuracy:.2f}%",
                "expected_sequence": " ".join(expected),
                "detected_sequence": " ".join(detected),
                "feedback": {
                    "phonetic_feedback": fb_phoneme if fb_phoneme else [{"detail": "Perfect Pronunciation.", "tip": None}],
                    "tajweed_feedback": fb_rule if fb_rule else [{"detail": "No Rule Broken.", "tip": None}]
                }
            }
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)