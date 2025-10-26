import os
from huggingface_hub import hf_hub_download
from llama_cpp import Llama
from fastapi import FastAPI

# Create FastAPI app
app = FastAPI()

# Model path
MODEL_PATH = "/models/7B-llama2.gguf"

# Download model at runtime if not exists
if not os.path.exists(MODEL_PATH):
    print("Downloading 7B model from Hugging Face...")
    hf_hub_download(
        repo_id="TheBloke/7B-llama2-GGUF",
        filename="7B-llama2.gguf",
        cache_dir="/models"
    )
    print("Download complete!")

# Initialize Llama
llm = Llama(model_path=MODEL_PATH)

# Sample endpoint
@app.get("/generate")
def generate(prompt: str):
    output = llm(prompt, max_tokens=64)
    return {"prompt": prompt, "completion": output["choices"][0]["text"]}

# Run server with uvicorn
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
