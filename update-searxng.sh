#!/bin/bash

LOG_FILE="/var/log/searxng-update.log"
COMPOSE_DIR="/home/changeme/searxng"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Change to the compose directory
cd "$COMPOSE_DIR" || {
    log_message "ERROR: Could not change to directory $COMPOSE_DIR"
    exit 1
}

log_message "Starting SearXNG update process..."

log_message "Pulling latest SearXNG image..."
if docker compose pull searxng; then
    log_message "Successfully pulled latest image"
else
    log_message "ERROR: Failed to pull latest image"
    exit 1
fi

CURRENT_IMAGE_ID=$(docker images --format "table {{.ID}}" searxng/searxng | tail -n +2 | head -n 1)
RUNNING_IMAGE_ID=$(docker inspect --format='{{.Image}}' searxng-searxng-1 2>/dev/null | cut -d: -f2 | cut -c1-12)

if [ "$CURRENT_IMAGE_ID" != "$RUNNING_IMAGE_ID" ]; then
    log_message "New image detected. Restarting SearXNG container..."
    
    # Restart the container with the new image
    if docker compose up -d searxng; then
        log_message "Successfully restarted SearXNG with new image"
        
        # Clean up old images
        log_message "Cleaning up old Docker images..."
        docker image prune -f
        
        log_message "Update completed successfully"
    else
        log_message "ERROR: Failed to restart SearXNG container"
        exit 1
    fi
else
    log_message "No updates available. SearXNG is already running the latest version."
fi

log_message "Update process finished."
