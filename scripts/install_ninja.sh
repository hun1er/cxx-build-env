#!/bin/bash
set -euo pipefail

# Define variables
NINJA_URL="https://github.com/ninja-build/ninja.git"
NINJA_SRC_DIR="ninja"
INITIAL_DIR="$(pwd)"

# Clone repository
git clone "$NINJA_URL" "$NINJA_SRC_DIR"
cd "$NINJA_SRC_DIR"
git checkout release

# Generate random string
generate_random_string() {
    local length=8
    tr -dc '[:lower:]' < /dev/urandom | head -c "$length" || true
}

# Create build directory
RANDOM_STRING="$(generate_random_string)"
NINJA_BUILD_DIR="$NINJA_SRC_DIR/build-$RANDOM_STRING"

# Configure build
cmake \
    -B"$NINJA_BUILD_DIR" \
    -DCMAKE_BUILD_TYPE=Release

# Build and install
cd "$NINJA_BUILD_DIR"
cmake --build . --parallel "$(nproc)"
make install
rm -f /usr/bin/ninja
ln -s /usr/local/bin/ninja /usr/bin/ninja

# Cleanup
cd "$INITIAL_DIR"
rm -rf "$NINJA_SRC_DIR"

# Print success message
echo ""
echo "Ninja build system installation completed successfully."
echo ""
