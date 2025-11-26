#!/usr/bin/env bash
set -euo pipefail

# Heavy Container Performance Benchmark Script
# Tests with realistic workloads: large images, many containers, heavy I/O

echo "=== Heavy Container Performance Benchmark ==="
echo "This will take 5-10 minutes to complete..."
echo ""

# Check storage drivers
echo "Storage Configuration:"
echo "  Docker: $(docker info 2>/dev/null | grep 'Storage Driver' | awk '{print $3}')"
echo "  Podman: $(podman info --format=json 2>/dev/null | grep -oP '"graphDriverName": "\K[^"]+')"
echo ""

# Test 1: Large Image Pulls
echo "Test 1: Large Image Pull Speed (postgres, node, python)"
docker rmi postgres:latest node:latest python:latest 2>/dev/null || true
echo "  Pulling postgres..."
time docker pull postgres:latest > /dev/null
echo "  Pulling node..."
time docker pull node:latest > /dev/null
echo "  Pulling python..."
time docker pull python:latest > /dev/null
echo ""

# Test 2: Many Container Starts
echo "Test 2: Container Start Time (100 iterations)"
total=0
for _ in {1..100}; do
  start=$(date +%s%N)
  docker run --rm alpine:latest echo "test" > /dev/null 2>&1
  end=$(date +%s%N)
  elapsed=$(((end - start) / 1000000))
  total=$((total + elapsed))
done
avg=$((total / 100))
echo "  Average start time: ${avg}ms (100 runs)"
echo ""

# Test 3: Heavy Filesystem I/O
echo "Test 3: Heavy Filesystem I/O"
echo "  Writing 10GB sequential..."
docker run --rm alpine:latest sh -c 'dd if=/dev/zero of=/tmp/test bs=1M count=10240 2>&1 | grep -E "copied|MB/s"'
echo "  Random write performance (1000 files of 10MB each)..."
time docker run --rm alpine:latest sh -c 'for i in $(seq 1 1000); do dd if=/dev/urandom of=/tmp/file$i bs=1M count=10 2>/dev/null; done'
echo ""

# Test 4: Complex Multi-stage Build
echo "Test 4: Complex Multi-stage Build"
tmpdir=$(mktemp -d)
cat > "$tmpdir/Dockerfile" <<'EOF'
FROM node:latest AS builder
WORKDIR /app
RUN dd if=/dev/zero of=/tmp/dummy1 bs=1M count=500
RUN npm install -g npm@latest
RUN dd if=/dev/zero of=/tmp/dummy2 bs=1M count=500

FROM python:latest AS python-builder
WORKDIR /app
RUN dd if=/dev/zero of=/tmp/dummy3 bs=1M count=500
RUN pip install --upgrade pip
RUN dd if=/dev/zero of=/tmp/dummy4 bs=1M count=500

FROM alpine:latest
WORKDIR /app
COPY --from=builder /tmp/dummy1 /app/
COPY --from=python-builder /tmp/dummy3 /app/
RUN dd if=/dev/zero of=/tmp/final bs=1M count=100
EOF
time docker build -q "$tmpdir" > /dev/null
rm -rf "$tmpdir"
echo ""

# Test 5: Layer Creation Performance
echo "Test 5: Layer Creation (50 layers)"
tmpdir=$(mktemp -d)
cat > "$tmpdir/Dockerfile" <<'EOF'
FROM alpine:latest
EOF
for i in $(seq 1 50); do
  echo "RUN dd if=/dev/zero of=/tmp/layer$i bs=1M count=20 && rm /tmp/layer$i" >> "$tmpdir/Dockerfile"
done
time docker build -q "$tmpdir" > /dev/null
rm -rf "$tmpdir"
echo ""

# Test 6: Concurrent Container Operations
echo "Test 6: Concurrent Container Starts (20 parallel)"
time for _ in {1..20}; do
  docker run --rm -d alpine:latest sleep 10 > /dev/null
done
docker ps -q | xargs -r docker stop > /dev/null 2>&1 || true
echo ""

# Test 7: Volume Operations
echo "Test 7: Volume I/O Performance"
vol_name="benchmark-vol-$(date +%s)"
docker volume create "$vol_name" > /dev/null
echo "  Writing 5GB to volume..."
docker run --rm -v "$vol_name":/data alpine:latest sh -c 'dd if=/dev/zero of=/data/test bs=1M count=5120 2>&1 | grep -E "copied|MB/s"'
echo "  Reading 5GB from volume..."
docker run --rm -v "$vol_name":/data alpine:latest sh -c 'dd if=/data/test of=/dev/null bs=1M 2>&1 | grep -E "copied|MB/s"'
docker volume rm "$vol_name" > /dev/null
echo ""

# Test 8: Image Layer Cache Performance
echo "Test 8: Build Cache Performance (rebuild same image 5 times)"
tmpdir=$(mktemp -d)
cat > "$tmpdir/Dockerfile" <<'EOF'
FROM python:latest
RUN pip install requests flask numpy pandas
RUN dd if=/dev/zero of=/tmp/data bs=1M count=200
EOF
echo "  First build (no cache):"
time docker build -q "$tmpdir" > /dev/null
echo "  Rebuilds (with cache):"
for i in {1..4}; do
  echo "    Build $i:"
  time docker build -q "$tmpdir" > /dev/null
done
rm -rf "$tmpdir"
echo ""

# Test 9: Snapshot/Copy Performance
echo "Test 9: Container Commit Performance"
cid=$(docker run -d postgres:latest sleep 30)
time docker commit "$cid" benchmark-snapshot:latest > /dev/null
docker stop "$cid" > /dev/null 2>&1 || true
docker rm "$cid" > /dev/null 2>&1 || true
docker rmi benchmark-snapshot:latest > /dev/null 2>&1 || true
echo ""

echo "=== Heavy Benchmark Complete ==="
echo ""
echo "Summary: Check the timing results above to compare storage drivers."
echo "Key metrics: Large image pulls, multi-stage builds, layer operations, and volume I/O."
