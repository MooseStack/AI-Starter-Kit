#!/bin/bash
set -e

python3 -m vllm.entrypoints.openai.api_server \
        --model=/models \
        --task embed \
        --max_model_len=512 \
        --dtype=bfloat16 \
        --host=0.0.0.0 \
        --port=8888 \
        --served-model-name=ibm-granite/granite-embedding-125m-english