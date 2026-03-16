#!/bin/bash
set -euo pipefail

# Define variables
BINUTILS_URL="https://ftpmirror.gnu.org/gnu/binutils/binutils-with-gold-$BINUTILS_VERSION.tar.gz"
BINUTILS_PREFIX="${BINUTILS_PREFIX:-/usr}"
BINUTILS_PROGRAM_PREFIX="${BINUTILS_PROGRAM_PREFIX:-}"
BINUTILS_TAR_FILE="binutils-with-gold.tar.gz"
BINUTILS_SRC_DIR="binutils-with-gold-$BINUTILS_VERSION"
INITIAL_DIR="$(pwd)"

# Download and extract source tarball
wget -O "$BINUTILS_TAR_FILE" "$BINUTILS_URL"
tar -xzf "$BINUTILS_TAR_FILE"

# Generate random string
generate_random_string() {
    local length=8
    tr -dc '[:lower:]' < /dev/urandom | head -c "$length" || true
}

# Create build directory
RANDOM_STRING="$(generate_random_string)"
BINUTILS_BUILD_DIR="$BINUTILS_SRC_DIR/build-$RANDOM_STRING"
mkdir -p "$BINUTILS_BUILD_DIR"

# Configure build
cd "$BINUTILS_BUILD_DIR"
../configure \
    --prefix="$BINUTILS_PREFIX" \
    --program-prefix="$BINUTILS_PROGRAM_PREFIX" \
    --enable-ld=yes \
    --enable-gold=yes \
    --enable-multilib \
    --disable-nls \
    --disable-werror

# Build and install
make -j"$(nproc)"
make install
ldconfig

# Cleanup
cd "$INITIAL_DIR"
rm -rf "$BINUTILS_SRC_DIR" "$BINUTILS_TAR_FILE"

# Print success message
echo ""
echo "GNU Binary Utilities version $BINUTILS_VERSION installation completed successfully."
echo ""
