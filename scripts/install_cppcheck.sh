#!/bin/bash
set -euo pipefail

# Define variables
CPPCHECK_URL="https://github.com/danmar/cppcheck/archive/$CPPCHECK_VERSION.tar.gz"
CPPCHECK_TAR_FILE="cppcheck.tar.gz"
CPPCHECK_SRC_DIR="cppcheck-$CPPCHECK_VERSION"
CPPCHECK_CFG_DIR="/usr/local/share/Cppcheck"
INITIAL_DIR="$(pwd)"

# Download and extract source tarball
wget -O "$CPPCHECK_TAR_FILE" "$CPPCHECK_URL"
tar -xf "$CPPCHECK_TAR_FILE"

# Generate random string
generate_random_string() {
    local length=8
    tr -dc '[:lower:]' < /dev/urandom | head -c "$length" || true
}

# Create build directory
RANDOM_STRING="$(generate_random_string)"
CPPCHECK_BUILD_DIR="$CPPCHECK_SRC_DIR/build-$RANDOM_STRING"
mkdir -p "$CPPCHECK_BUILD_DIR"

# Configure build
cd "$CPPCHECK_BUILD_DIR"
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_GUI=OFF \
    -DHAVE_RULES=ON \
    -DUSE_MATCHCOMPILER=ON \
    ..

# Build and install
cmake --build . --parallel "$(nproc)"
mkdir -p "$CPPCHECK_CFG_DIR"
cp -r "../cfg" "$CPPCHECK_CFG_DIR"
make install

# Cleanup
cd "$INITIAL_DIR"
rm -rf "$CPPCHECK_SRC_DIR" "$CPPCHECK_TAR_FILE"

# Print success message
echo ""
echo "Cppcheck version $CPPCHECK_VERSION installation completed successfully."
echo ""
