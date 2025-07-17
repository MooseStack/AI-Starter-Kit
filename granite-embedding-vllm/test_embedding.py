## This script tests the vLLM embedding endpoint for the Granite model.
## Execute like: python3 granite-embedding-vllm/test_embedding.py

import requests
import json

# Replace with your vLLM container host and port
VLLM_EMBEDDING_ENDPOINT = "http://localhost:8888/v1/embeddings"

def get_embedding(text):
    headers = {
        "Content-Type": "application/json"
    }

    payload = {
        "input": text,
        "model": "ibm-granite/granite-embedding-125m-english"
    }

    try:
        response = requests.post(VLLM_EMBEDDING_ENDPOINT, headers=headers, data=json.dumps(payload))
        response.raise_for_status()
        data = response.json()
        embedding = data['data'][0]['embedding']
        return embedding
    except requests.exceptions.RequestException as e:
        print("HTTP Request failed:", e)
    except Exception as e:
        print("Error parsing response:", e)

# Example usage
if __name__ == "__main__":
    text = "The castle was built in the 12th century and is a fine example of medieval architecture."
    vector = get_embedding(text)
    
    print(f"Embedding: '{text}' \n")
    print(f"Embedding vector response from granite model: '{vector}'")
