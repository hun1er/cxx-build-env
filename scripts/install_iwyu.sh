#!/bin/bash
set -euo pipefail

# Define variables
IWYU_URL="https://github.com/include-what-you-use/include-what-you-use.git"
IWYU_SRC_DIR="include-what-you-use"
CLANG_VERSION="${CLANG_VERSION:-19}"
IWYU_PREFIX="${IWYU_PREFIX:-/usr/lib/llvm-$CLANG_VERSION}"
INITIAL_DIR="$(pwd)"

# Clone repository
git clone "$IWYU_URL" "$IWYU_SRC_DIR"
cd "$IWYU_SRC_DIR"
git checkout "clang_$CLANG_VERSION"
cd "$INITIAL_DIR"

# Generate random string
generate_random_string() {
    local length=8
    tr -dc '[:lower:]' < /dev/urandom | head -c "$length" || true
}

# Create build directory
RANDOM_STRING="$(generate_random_string)"
IWYU_BUILD_DIR="$IWYU_SRC_DIR/build-$RANDOM_STRING"
mkdir -p "$IWYU_BUILD_DIR"

# Configure build
cd "$IWYU_BUILD_DIR"
cmake \
    -G "Unix Makefiles" \
    -DCMAKE_PREFIX_PATH="$IWYU_PREFIX" \
    ..

# Build and install
make -j"$(nproc)"
make install

# Cleanup
cd "$INITIAL_DIR"
rm -rf "$IWYU_SRC_DIR"

# Print success message
echo ""
echo "Include What You Use version $CLANG_VERSION installation completed successfully."
echo ""
