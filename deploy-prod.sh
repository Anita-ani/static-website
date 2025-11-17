#!/bin/bash
set -e

echo "Starting production deployment for iPayBTC Landing Page..."

cd /home/ubuntu/ipaybtc-landing-page

echo "Pulling latest changes from main branch..."
git fetch origin main
git reset --hard origin/main

echo "Stopping existing containers..."
docker compose down

echo "Building Docker image..."
docker compose build --no-cache

echo "Starting new container..."
docker compose up -d

echo "Waiting for container to start..."
sleep 3

echo "Verifying deployment..."
if docker compose ps | grep -q "Up"; then
    echo "✓ Container is running successfully"
else
    echo "✗ Deployment failed - checking logs..."
    docker compose logs --tail=50
    exit 1
fi

echo "Cleaning up unused Docker images..."
docker image prune -f

echo "================================================"
echo "Production deployment completed successfully!"
echo "Application is running on port 4000"
echo "================================================"
