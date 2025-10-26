# Use official Python slim image
FROM python:3.11-slim

# Set environment variables to avoid prompts during install
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir huggingface-hub

# Copy all app code
COPY . .

# Create models directory
RUN mkdir -p /models

# Download Hugging Face model (example 7B LLaMA2 GGUF)
RUN python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='TheBloke/7B-llama2-GGUF', filename='7B-llama2.gguf', cache_dir='/models')"

# Expose API port
EXPOSE 8000

# Command to run your app
CMD ["python", "main.py"]
