#!/bin/bash
# Open WebUI Setup — ChatGPT-like interface for your local Ollama models
# Requires: Docker Desktop running
#
# Usage: ./scripts/setup-open-webui.sh
# Access: http://localhost:3000

set -e

echo "Setting up Open WebUI..."

# Check Docker
if ! command -v docker &> /dev/null; then
  echo "Error: Docker not installed. Install Docker Desktop first."
  echo "  brew install --cask docker"
  exit 1
fi

if ! docker info > /dev/null 2>&1; then
  echo "Error: Docker is not running. Start Docker Desktop first."
  exit 1
fi

# Check if already running
if docker ps --filter name=open-webui --format "{{.Names}}" | grep -q open-webui; then
  echo "Open WebUI is already running!"
  echo "Access: http://localhost:3000"
  docker ps --filter name=open-webui --format "  Status: {{.Status}}"
  exit 0
fi

# Remove old container if exists
docker rm -f open-webui 2>/dev/null || true

# Start Open WebUI
echo "Pulling and starting Open WebUI..."
docker run -d \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main

echo ""
echo "Waiting for startup..."
sleep 10

# Check health
STATUS=$(docker ps --filter name=open-webui --format "{{.Status}}")
echo "Status: $STATUS"

echo ""
echo "Done! Open WebUI is running."
echo "  Access: http://localhost:3000"
echo "  First visit: create an admin account (local only, no data sent anywhere)"
echo "  Your Ollama models will appear in the model dropdown"
echo ""
echo "Management:"
echo "  docker stop open-webui    # Stop"
echo "  docker start open-webui   # Start"
echo "  docker logs open-webui    # View logs"
