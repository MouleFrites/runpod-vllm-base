#!/usr/bin/env bash
set -euo pipefail

# obligatoire
if [ -z "${MODEL_NAME:-}" ]; then
  echo "ERROR: MODEL_NAME is not set"
  echo "Example:"
  echo "MODEL_NAME=google/gemma-3-12b-it start-vllm.sh"
  exit 1
fi

HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8000}"
API_KEY="${API_KEY:-token-abc123}"
DTYPE="${DTYPE:-auto}"
MAX_MODEL_LEN="${MAX_MODEL_LEN:-8192}"
GPU_MEMORY_UTILIZATION="${GPU_MEMORY_UTILIZATION:-0.95}"
TENSOR_PARALLEL_SIZE="${TENSOR_PARALLEL_SIZE:-1}"
TRUST_REMOTE_CODE="${TRUST_REMOTE_CODE:-false}"
EXTRA_ARGS="${EXTRA_ARGS:-}"

mkdir -p /workspace/.cache/huggingface

CMD=(
  python -m vllm.entrypoints.openai.api_server
  --host "$HOST"
  --port "$PORT"
  --model "$MODEL_NAME"
  --dtype "$DTYPE"
  --max-model-len "$MAX_MODEL_LEN"
  --gpu-memory-utilization "$GPU_MEMORY_UTILIZATION"
  --tensor-parallel-size "$TENSOR_PARALLEL_SIZE"
  --api-key "$API_KEY"
)

if [ "$TRUST_REMOTE_CODE" = "true" ]; then
  CMD+=(--trust-remote-code)
fi

if [ -n "$EXTRA_ARGS" ]; then
  # permet de passer des flags custom
  # ex: EXTRA_ARGS="--enable-prefix-caching"
  CMD+=($EXTRA_ARGS)
fi

echo "Launching vLLM with model: $MODEL_NAME"
exec "${CMD[@]}"