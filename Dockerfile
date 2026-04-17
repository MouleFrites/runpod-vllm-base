FROM vllm/vllm-openai:v0.19.0-x86_64-cu130-ubuntu2404

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    tmux \
    jq \
    && rm -rf /var/lib/apt/lists/*

RUN uv pip install --system \
    huggingface_hub \
    accelerate \
    sentencepiece \
    safetensors \
    datasets

# support modèles récents
RUN uv pip install --system git+https://github.com/huggingface/transformers.git

ENV HF_HOME=/workspace/.cache/huggingface
ENV HUGGINGFACE_HUB_CACHE=/workspace/.cache/huggingface/hub
ENV PYTHONUNBUFFERED=1

COPY start-vllm.sh /usr/local/bin/start-vllm.sh
RUN chmod +x /usr/local/bin/start-vllm.sh

WORKDIR /workspace

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/start-vllm.sh"]
