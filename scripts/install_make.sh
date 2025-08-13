#!/bin/bash
set -euo pipefail

# Define variables
MAKE_URL="https://ftpmirror.gnu.org/gnu/make/make-$MAKE_VERSION.tar.gz"
MAKE_PREFIX="${MAKE_PREFIX:-/usr}"
MAKE_PROGRAM_PREFIX="${MAKE_PROGRAM_PREFIX:-}"
MAKE_TAR_FILE="make.tar.gz"
MAKE_SRC_DIR="make-$MAKE_VERSION"
INITIAL_DIR="$(pwd)"

# Download and extract source tarball
wget -O "$MAKE_TAR_FILE" "$MAKE_URL"
tar -xzf "$MAKE_TAR_FILE"

# Generate random string
generate_random_string() {
    local length=8
    tr -dc '[:lower:]' < /dev/urandom | head -c "$length" || true
}

# Create build directory
RANDOM_STRING="$(generate_random_string)"
MAKE_BUILD_DIR="$MAKE_SRC_DIR/build-$RANDOM_STRING"
mkdir -p "$MAKE_BUILD_DIR"

# Configure build
cd "$MAKE_BUILD_DIR"
../configure \
    --prefix="$MAKE_PREFIX" \
    --program-prefix="$MAKE_PROGRAM_PREFIX" \
    --disable-nls

# Build and install
make -j"$(nproc)"
make install
ldconfig

# Cleanup
cd "$INITIAL_DIR"
rm -rf "$MAKE_SRC_DIR" "$MAKE_TAR_FILE"

# Print success message
echo ""
echo "GNU Make version $MAKE_VERSION installation completed successfully."
echo ""
