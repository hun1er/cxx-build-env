#!/bin/bash
set -euo pipefail

# Define variables
ELFKICKERS_URL="https://github.com/BR903/ELFkickers.git"
ELFKICKERS_SRC_DIR="elfkickers"
INITIAL_DIR="$(pwd)"

# Clone repository
git clone "$ELFKICKERS_URL" "$ELFKICKERS_SRC_DIR"

# Build and install
cd "$ELFKICKERS_SRC_DIR"
make --jobs="$(nproc)"
make install

# Cleanup
cd "$INITIAL_DIR"
rm -rf "$ELFKICKERS_SRC_DIR"

# Print success message
echo ""
echo "ELFkickers installation completed successfully."
echo ""
