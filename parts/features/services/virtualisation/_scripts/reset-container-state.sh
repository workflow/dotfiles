#!/usr/bin/env bash
set -euo pipefail

# Reset container state for fair benchmarking
# This clears all images, containers, volumes, caches, and storage backends
# Works when switching between overlay2 and btrfs drivers

echo "=== Resetting Container State ==="
echo ""

# Check current storage driver before cleanup
echo "Current storage configuration:"
docker info 2>/dev/null | grep 'Storage Driver' || echo "  Docker: not running"
podman info --format=json 2>/dev/null | grep -oP '"graphDriverName": "\K[^"]+' | sed 's/^/  Podman: /' || echo "  Podman: not running"
echo ""

# Stop all running containers (if services are running)
echo "Stopping all containers..."
containers=$(docker ps -aq 2>/dev/null || true)
if [ -n "$containers" ]; then
  docker stop "$containers" 2>/dev/null || true
  docker rm -f "$containers" 2>/dev/null || true
fi
podman stop -a 2>/dev/null || true
podman rm -a -f 2>/dev/null || true

# Remove all images via API (cleans metadata properly)
echo "Removing all images..."
images=$(docker images -aq 2>/dev/null || true)
if [ -n "$images" ]; then
  docker rmi -f "$images" 2>/dev/null || true
fi
podman rmi -a -f 2>/dev/null || true

# Remove all volumes
echo "Removing all volumes..."
volumes=$(docker volume ls -q 2>/dev/null || true)
if [ -n "$volumes" ]; then
  docker volume rm "$volumes" 2>/dev/null || true
fi
podman volume rm -a -f 2>/dev/null || true

# Prune everything to clean build cache and metadata
echo "Pruning system..."
docker system prune -a -f --volumes 2>/dev/null || true
podman system prune -a -f --volumes 2>/dev/null || true

# Stop services before cleaning storage
echo "Stopping Docker and Podman services..."
sudo systemctl stop docker.socket docker.service 2>/dev/null || true
sudo systemctl stop podman.socket podman.service 2>/dev/null || true

# Wait for services to fully stop
sleep 2

# Remove all Docker storage (both overlay2 and btrfs)
echo "Removing all Docker storage backends..."
sudo rm -rf /var/lib/docker/* 2>/dev/null || true

# Remove all Podman storage
echo "Removing all Podman storage..."
sudo rm -rf /var/lib/containers/storage/* 2>/dev/null || true
rm -rf ~/.local/share/containers/storage/* 2>/dev/null || true

# Podman system reset (if podman can start)
echo "Resetting Podman state..."
podman system reset -f 2>/dev/null || true

# Restart services with clean storage
echo "Restarting Docker and Podman services..."
sudo systemctl start docker.service
sudo systemctl start podman.service

# Wait for services to be ready
sleep 3

# Verify clean state
echo ""
echo "Verifying clean state..."
docker images 2>/dev/null && echo "  Docker: Clean (no images)" || echo "  Docker: Service starting..."
podman images 2>/dev/null && echo "  Podman: Clean (no images)" || echo "  Podman: Service starting..."

# Drop system caches for fair benchmarking
echo ""
echo "Dropping system caches..."
sudo sync
echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

echo ""
echo "=== Container State Reset Complete ==="
echo "All storage backends (overlay2, btrfs) have been cleared."
echo "New storage driver configuration:"
docker info 2>/dev/null | grep 'Storage Driver' || echo "  Docker: initializing..."
podman info --format=json 2>/dev/null | grep -oP '"graphDriverName": "\K[^"]+' | sed 's/^/  Podman: /' || echo "  Podman: initializing..."
echo ""
echo "Ready to run benchmarks with clean storage!"
