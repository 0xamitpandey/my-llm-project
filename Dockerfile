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

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy application code
COPY . .

# Create models directory
RUN mkdir -p /models

# Expose port for API
EXPOSE 8000

# Command to run your app
CMD ["python", "main.py"]
