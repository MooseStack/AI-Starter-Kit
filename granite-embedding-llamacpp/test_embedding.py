## This script tests the embedding endpoint for the Granite model.
## Execute like: python3 granite-embedding-llamacpp/test_embedding.py

## Response should return a bunch of numbers representing the embedding vector for the input text.

import requests
import json
import os

EMBEDDING_ENDPOINT = "http://localhost:8888/v1/embeddings"
MODEL_NAME = os.environ.get("GRANITE_EMBEDDING_MODEL", "ibm-granite/granite-embedding-125m-english")

def get_embedding(text, model_name=MODEL_NAME):
    headers = {
        "Content-Type": "application/json"
    }

    payload = {
        "input": text,
        "model": model_name
    }

    try:
        response = requests.post(EMBEDDING_ENDPOINT, headers=headers, data=json.dumps(payload))
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
