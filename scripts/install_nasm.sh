#!/bin/bash
set -euo pipefail

# Define variables
NASM_URL="https://www.nasm.us/pub/nasm/releasebuilds/$NASM_VERSION/nasm-$NASM_VERSION.tar.gz"
NASM_SRC_DIR="nasm-$NASM_VERSION"
NASM_TAR_FILE="nasm.tar.gz"
NASM_PREFIX="${NASM_PREFIX:-/usr}"
INITIAL_DIR="$(pwd)"

# Download and extract source tarball
wget -O "$NASM_TAR_FILE" "$NASM_URL"
tar -xzf "$NASM_TAR_FILE"

# Generate random string
generate_random_string() {
    local length=8
    tr -dc '[:lower:]' < /dev/urandom | head -c "$length" || true
}

# Create build directory
RANDOM_STRING="$(generate_random_string)"
NASM_BUILD_DIR="$NASM_SRC_DIR/build-$RANDOM_STRING"
mkdir -p "$NASM_BUILD_DIR"

# Configure build
cd "$NASM_BUILD_DIR"
../configure \
    --prefix="$NASM_PREFIX"

# Build and install
make -j"$(nproc)"
make strip
make install

# Cleanup
cd "$INITIAL_DIR"
rm -rf "$NASM_SRC_DIR" "$NASM_TAR_FILE"

# Print success message
echo ""
echo "NASM version $NASM_VERSION installation completed successfully."
echo ""
