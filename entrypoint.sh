#!/bin/sh
set -eu
export HF_HUB_OFFLINE=1
export TRANSFORMERS_OFFLINE=1
export VLLM_NO_USAGE_STATS=1
exec vllm serve "$@"