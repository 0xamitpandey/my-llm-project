# Use official Python image
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create models directory
RUN mkdir -p /models

# Optionally download a Hugging Face model (uncomment if needed)
# RUN python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='TheBloke/7B-llama2-GGUF', filename='7B-llama2.gguf', cache_dir='/models')"

# Expose port for API
EXPOSE 8000

# Run the FastAPI server with uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
