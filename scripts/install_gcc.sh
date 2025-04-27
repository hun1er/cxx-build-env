#!/bin/bash
set -euo pipefail

# Define variables
GCC_URL="https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz"
GCC_PREFIX="${GCC_PREFIX:-/usr}"
GCC_PROGRAM_PREFIX="${GCC_PROGRAM_PREFIX:-}"
GCC_TAR_FILE="gcc.tar.gz"
GCC_SRC_DIR="gcc-$GCC_VERSION"
INITIAL_DIR="$(pwd)"

# Download and extract source tarball
wget -O "$GCC_TAR_FILE" "$GCC_URL"
tar -xzf "$GCC_TAR_FILE"

# Download prerequisites
cd "$GCC_SRC_DIR"
./contrib/download_prerequisites
cd "$INITIAL_DIR"

# Generate random string
generate_random_string() {
    local length=8
    tr -dc '[:lower:]' < /dev/urandom | head -c "$length" || true
}

# Create build directory
RANDOM_STRING="$(generate_random_string)"
GCC_BUILD_DIR="$GCC_SRC_DIR/build-$RANDOM_STRING"
mkdir -p "$GCC_BUILD_DIR"

# Configure build
cd "$GCC_BUILD_DIR"
../configure \
    --prefix="$GCC_PREFIX" \
    --program-prefix="$GCC_PROGRAM_PREFIX" \
    --disable-bootstrap \
    --disable-checking \
    --disable-nls \
    --disable-werror \
    --enable-languages=c,c++ \
    --enable-multilib \
    --enable-shared \
    --enable-static \
    --enable-threads=posix \
    --with-multilib-list=m32,m64

# Build and install
make -j"$(nproc)"
make install
ldconfig

# Cleanup
cd "$INITIAL_DIR"
rm -rf "$GCC_SRC_DIR" "$GCC_TAR_FILE"

# Print success message
echo ""
echo "GNU Compiler Collection version $GCC_VERSION installation completed successfully."
echo ""
