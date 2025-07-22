import os
from huggingface_hub import snapshot_download

# Get the model repo from the environment variable
huggingface_model_repo = os.environ["HUGGINGFACE_MODEL_REPO"]

snapshot_download(
    repo_id=huggingface_model_repo,
    local_dir="/models",
    allow_patterns=["*.safetensors", "*.json", "*.txt"],
)