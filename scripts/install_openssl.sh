#!/bin/bash
set -euo pipefail

# Define variables
OPENSSL_VERSION="$OPENSSL_VERSION"
OPENSSL_URL="https://github.com/openssl/openssl/releases/download/openssl-$OPENSSL_VERSION/openssl-$OPENSSL_VERSION.tar.gz"
OPENSSL_TAR_FILE="openssl.tar.gz"
OPENSSL_SRC_DIR="openssl-$OPENSSL_VERSION"
OPENSSL32_PREFIX="${OPENSSL32_PREFIX:-/usr/local/openssl/32}"
OPENSSL64_PREFIX="${OPENSSL64_PREFIX:-/usr/local/openssl/64}"
INITIAL_DIR="$(pwd)"

# Download and extract source tarball
wget -O "$OPENSSL_TAR_FILE" "$OPENSSL_URL"
tar -xzf "$OPENSSL_TAR_FILE"

# Generate random string
generate_random_string() {
    local length=8
    tr -dc '[:lower:]' < /dev/urandom | head -c "$length" || true
}

# Create build directory (64-bit)
RANDOM_STRING_64="$(generate_random_string)"
OPENSSL64_BUILD_DIR="$OPENSSL_SRC_DIR/build-64-$RANDOM_STRING_64"
mkdir -p "$OPENSSL64_BUILD_DIR"

# Configure build (64-bit)
cd "$OPENSSL64_BUILD_DIR"
../Configure linux-x86_64 \
    --prefix="$OPENSSL64_PREFIX" \
    --openssldir="$OPENSSL64_PREFIX/ssl" \
    '-Wl,-rpath,$(LIBRPATH)'

# Build and install (64-bit)
make -j"$(nproc)"
make install_sw
cd "$INITIAL_DIR"

# Create build directory (32-bit)
RANDOM_STRING_32="$(generate_random_string)"
OPENSSL32_BUILD_DIR="$OPENSSL_SRC_DIR/build-32-$RANDOM_STRING_32"
mkdir -p "$OPENSSL32_BUILD_DIR"

# Configure build (32-bit)
cd "$OPENSSL32_BUILD_DIR"
../Configure linux-x86 \
    --prefix="$OPENSSL32_PREFIX" \
    --openssldir="$OPENSSL32_PREFIX/ssl" \
    '-Wl,-rpath,$(LIBRPATH)'

# Build and install (32-bit)
make -j"$(nproc)"
make install_sw
cd "$INITIAL_DIR"

# Cleanup
rm -rf "$OPENSSL_SRC_DIR" "$OPENSSL_TAR_FILE"

# Print success message
echo ""
echo "OpenSSL version $OPENSSL_VERSION installation completed successfully."
echo "  64-bit: $OPENSSL64_PREFIX  (lib64/)"
echo "  32-bit: $OPENSSL32_PREFIX  (lib/)"
echo "  Both include static (.a) and shared (.so) libraries."
echo ""
