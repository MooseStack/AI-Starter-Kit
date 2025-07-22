#!/bin/bash
set -e

cd /app

## Convert Hugging Face model to GGUF format (something that llama.cpp requires)
/app/convert_hf_to_gguf.py /models --outfile /models/model.gguf

## Start an OpenAI-compatible server using the converted GGUF model
/app/llama-server \
    --model /models/model.gguf \
    --embedding \
    --port 8888 \
    --host 0.0.0.0 \
    -n 512