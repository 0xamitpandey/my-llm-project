# Base image
FROM python:3.13-slim

# Set workdir
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libopenblas-dev \
        ninja-build \
        && rm -rf /var/lib/apt/lists/*

# Copy app
COPY ./app /app

# Install Python dependencies
RUN pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt

# Make models directory
RUN mkdir -p /models

# Download model from Hugging Face (example 7B)
RUN python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='TheBloke/7B-llama2-GGUF', filename='7B-llama2.gguf', cache_dir='/models')"

# Expose port
EXPOSE 8000

# Start FastAPI with uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
