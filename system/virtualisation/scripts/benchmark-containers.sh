#!/usr/bin/env bash
set -euo pipefail

# Container Performance Benchmark Script
# Tests image pull, container start, and filesystem I/O performance

echo "=== Container Performance Benchmark ==="
echo ""

# Check storage drivers
echo "Storage Configuration:"
echo "  Docker: $(docker info 2>/dev/null | grep 'Storage Driver' | awk '{print $3}')"
echo "  Podman: $(podman info --format=json 2>/dev/null | grep -oP '"graphDriverName": "\K[^"]+')"
echo ""

# Test 1: Image Pull Speed
echo "Test 1: Image Pull Speed (alpine:latest)"
docker rmi alpine:latest 2>/dev/null || true
time docker pull alpine:latest
echo ""

# Test 2: Container Start Time (10 iterations)
echo "Test 2: Container Start Time (10 iterations)"
total=0
for _ in {1..10}; do
  start=$(date +%s%N)
  docker run --rm alpine:latest echo "test" > /dev/null
  end=$(date +%s%N)
  elapsed=$(((end - start) / 1000000))
  total=$((total + elapsed))
done
avg=$((total / 10))
echo "  Average start time: ${avg}ms"
echo ""

# Test 3: Filesystem I/O Performance
echo "Test 3: Filesystem I/O (writing 1GB)"
docker run --rm alpine:latest sh -c 'dd if=/dev/zero of=/tmp/test bs=1M count=1024 2>&1 | grep -E "copied|MB/s"'
echo ""

# Test 4: Build Performance
echo "Test 4: Build Performance (simple Dockerfile)"
tmpdir=$(mktemp -d)
cat > "$tmpdir/Dockerfile" <<'EOF'
FROM alpine:latest
RUN apk add --no-cache curl git
RUN dd if=/dev/zero of=/tmp/test bs=1M count=100
EOF
time docker build -q "$tmpdir" > /dev/null
rm -rf "$tmpdir"
echo ""

echo "=== Benchmark Complete ==="
