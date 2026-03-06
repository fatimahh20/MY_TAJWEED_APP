import os

espeak_path = r"C:\Program Files\eSpeak NG"
dll_path = r"C:\Program Files\eSpeak NG\libespeak-ng.dll"

os.environ["PHONEMIZER_ESPEAK_LIBRARY"] = dll_path
os.environ["ESPEAKNG_VOICE"] = "ar"
os.environ["PATH"] = espeak_path + os.pathsep + os.environ["PATH"]

if hasattr(os, "add_dll_directory"):
    os.add_dll_directory(espeak_path)

from phonemizer.backend import EspeakBackend

backend = EspeakBackend('ar')
print("✅ Arabic phonemizer ready!")
print(backend.phonemize(["السلام عليكم"], strip=True))
