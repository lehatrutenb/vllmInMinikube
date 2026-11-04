#!/bin/sh
set -eu
export HF_HUB_OFFLINE=1
export TRANSFORMERS_OFFLINE=1
export VLLM_NO_USAGE_STATS=1
export VLLM_ENABLE_LOG_REQUESTS=1

model_name=${MODEL_ID##*/}
model_name=$(printf '%s' "$model_name" | tail -c 255)
exec vllm serve "${MODELS_DIR}/${model_name}" "$@"