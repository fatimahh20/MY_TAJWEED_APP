from huggingface_hub import upload_file

# Replace 'your-username' with your actual Hugging Face username
upload_file(
    path_or_fileobj="data/metadata.xlsm",
    path_in_repo="data/metadata.xlsm",
    repo_id="ymuteeah/tajweed_backend",
    repo_type="model" # Change to "dataset" if your repo is a Dataset repo
)