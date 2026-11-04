#!/usr/bin/env python3
import os
import sys
from pathlib import Path

from huggingface_hub import snapshot_download

model_id = os.environ.get("MODEL_ID")
root = Path(os.environ.get("MODELS_DIR"))
force_download = os.environ.get("FORCE_DOWNLOAD") == "1"
dest = root / model_id.split("/")[-1][-255:]
marker = dest / f".{model_id.split('/')[-1][-255:]}"
token = os.environ.get("HUGGING_FACE_TOKEN") or None

if force_download:
    Path(marker).unlink(missing_ok=True)

if marker.is_file():
    print(f"weights already at {dest}, skip download")
    sys.exit(0)

dest.mkdir(parents=True, exist_ok=True)
snapshot_download(repo_id=model_id, local_dir=str(dest), token=token)

Path(marker).touch()
print(f"saved weights to {dest}")