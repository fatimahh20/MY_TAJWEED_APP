import pandas as pd

print("⏳ Loading metadata...")

df = pd.read_excel("metadata.xlsm", engine="openpyxl")
df.columns = df.columns.str.lower()

print("✅ Metadata loaded")
