# Start from Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Make model directory
RUN mkdir -p /models

# Copy app code
COPY . .

# Set environment variables (these should be added as Render secrets)
ENV HF_TOKEN=${HF_TOKEN}   # Your Hugging Face token
ENV OTHER_KEY=${OTHER_KEY} # Any other key you need

# Download the model using the HF token
RUN python -c "from huggingface_hub import hf_hub_download; import os; \
hf_hub_download(repo_id='TheBloke/7B-llama2-GGUF', filename='7B-llama2.gguf', cache_dir='/models', token=os.environ['HF_TOKEN'])"

# Expose port
EXPOSE 8080

# Start the app
CMD ["python", "app.py"]
