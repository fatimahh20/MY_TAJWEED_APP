from fastapi import FastAPI, UploadFile, File, Query, HTTPException
import pandas as pd
import os
import shutil
import librosa
from utils.alignment import forced_align, processor
from utils.audio_handler import get_full_analysis

app = FastAPI(title="Tajweed AI Backend")

# Load Metadata
# Ensure the path "data/metadata.xlsm" is correct in your VS Code explorer
df = pd.read_excel("data/metadata.xlsm", engine="openpyxl")
df.columns = df.columns.str.lower()

@app.post("/upload-audio")
async def analyze_tajweed(
    # 1. Capture 'word_id' from the URL (?word_id=...) to match Dart code
    word_id: str = Query(...), 
    # 2. Capture the audio file from the multipart request body
    file: UploadFile = File(...)
):
    # Setup temporary path for audio processing
    temp_path = f"uploads/{file.filename}"
    os.makedirs("uploads", exist_ok=True)
    
    with open(temp_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    try:
        # 1. Metadata Lookup
        # We use .strip() to remove any hidden spaces from the ID
        res = df[df["id"] == word_id.strip()]
        if res.empty:
            raise HTTPException(status_code=404, detail=f"Word ID '{word_id}' not found in Excel")
        
        row = res.iloc[0]

        # 2. AI Inference
        # Returns predicted_ids and frames needed for the full Colab analysis
        audio_len = librosa.get_duration(path=temp_path)
        pred_ids, frames, _ = forced_align(temp_path)
        
        # 3. Full Analysis Logic (Replicating your Colab Cells 3 & 4)
        accuracy, feedback, segments, expected, detected = get_full_analysis(
            row["phenome"], pred_ids, frames, audio_len, processor
        )

        # 4. Construct response to match Dart's 'data.containsKey("message")'
        status_text = "MUMTAZ" if accuracy >= 80 else "Do More Practise"
        result_message = f"Accuracy: {accuracy:.2f}%\nStatus: {status_text}"

        return {
 # Found by data.containsKey('message')
         "tajweed_report": {
        "accuracy": f"{accuracy:.2f}%",
        "status": status_text,
        "feedback"  : feedback,
        "expected_sequence": " ".join(expected),
        "detected_sequence": " ".join(detected),
        
    }
}

    except Exception as e:
        # Provides detail in terminal if the AI or File processing fails
        print(f"Error during analysis: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
        
    finally:
        # Clean up the file to prevent server storage from filling up
        if os.path.exists(temp_path):
            os.remove(temp_path)

# Run this usig: uvicorn app:app --host 0.0.0.0 --port 8080
if __name__ == "__main__":
    import uvicorn
    # This is the "Explicit URL" logic you had before
    # Replace the IP with your Laptop's current IP from ipconfig
    uvicorn.run(app, host="10.42.188.74", port=8080)