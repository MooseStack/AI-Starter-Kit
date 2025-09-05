## This script tests streaming genai responses with the Granite model.
## Execute like: python3 granite-instruct-llamacpp/test_model.py

## Response should stream the model's response to the prompt in real-time.

import requests
import json
import os

CHAT_ENDPOINT = "http://localhost:8080/v1/chat/completions"
MODEL_NAME = os.environ.get("GRANITE_MODEL", "ibm-granite/granite-3.3-2b-instruct")

def stream_genai_response(prompt, model_name=MODEL_NAME):
    headers = {
        "Content-Type": "application/json"
    }
    payload = {
        "model": model_name,
        "messages": [
            {"role": "user", "content": prompt}
        ],
        "max_tokens": 128,
        "stream": True
    }
    with requests.post(CHAT_ENDPOINT, headers=headers, data=json.dumps(payload), stream=True, verify=False) as response:
        response.raise_for_status()
        print("GenAI streaming response:")
        for line in response.iter_lines():
            if line:
                data = line.decode("utf-8")
                if data.startswith("data: "):
                    data = data[6:]
                if data.strip() == "[DONE]":
                    break
                try:
                    chunk = json.loads(data)
                    content = chunk["choices"][0]["delta"].get("content", "")
                    print(content, end="", flush=True)
                except Exception:
                    continue
        print("\n")


if __name__ == "__main__":
    prompt = "Explain the difference between AI and machine learning."
    print(f"Question: {prompt}\n")
    stream_genai_response(prompt)