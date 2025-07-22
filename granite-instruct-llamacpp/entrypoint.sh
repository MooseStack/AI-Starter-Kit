#!/bin/bash
set -e

cd /app

## Convert Hugging Face model to GGUF format (something that llama.cpp requires)
/app/convert_hf_to_gguf.py /models --outfile /models/model.gguf

## Start an OpenAI-compatible server using the converted GGUF model
## --jinja allows for RAG(retrieval-augmented generation) / Function Calling
/app/llama-server \
    --model /models/model.gguf \
    --port 8080 \
    --host 0.0.0.0 \
    --jinja \
    -n 512