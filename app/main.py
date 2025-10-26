from fastapi import FastAPI
from llama_cpp import Llama

app = FastAPI(title="LLM API")

# Load the model (downloaded in /models)
llm = Llama(model_path="/models/7B-llama2.gguf")

@app.get("/")
def root():
    return {"message": "LLM API is running!"}

@app.post("/completion")
def completion(prompt: str, max_tokens: int = 32):
    output = llm(prompt, max_tokens=max_tokens)
    return {"output": output}
