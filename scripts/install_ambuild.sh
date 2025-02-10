#!/bin/bash
set -euo pipefail

# Define variables
AMBUILD_URL="https://github.com/alliedmodders/ambuild"
AMBUILD_SRC_DIR="ambuild"

# Clone repository
git clone "$AMBUILD_URL" "$AMBUILD_SRC_DIR"

# Install
PIP_VERSION=$(pip3 --version | awk '{print $2}')
PIP_MAJOR_VERSION=$(echo "$PIP_VERSION" | cut -d. -f1)
if [ "$PIP_MAJOR_VERSION" -ge 23 ]; then
    pip3 install --break-system-packages ./"$AMBUILD_SRC_DIR"
else
    pip3 install ./"$AMBUILD_SRC_DIR"
fi

# Cleanup
rm -rf "$AMBUILD_SRC_DIR"

# Print success message
echo ""
echo "AMBuild installation completed successfully."
echo ""
