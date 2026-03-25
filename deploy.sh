#!/bin/bash

echo "Stopping old container..."
docker stop siva-nginx || true
docker rm siva-nginx || true

echo "Running new container..."
docker run -d -p 80:80 --name siva-nginx sivacs2004/dev:latest

echo "Deployment Completed"
