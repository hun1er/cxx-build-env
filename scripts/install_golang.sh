#!/bin/bash
set -euo pipefail

# Define variables
GOLANG_URL="https://go.dev/dl/go$GOLANG_VERSION.linux-amd64.tar.gz"
GOLANG_TAR_FILE="go.linux-amd64.tar.gz"

# Download and extract source tarball
wget -O "$GOLANG_TAR_FILE" "$GOLANG_URL"

# Remove existing Go installation
rm -rf /usr/local/go
rm -f /usr/local/bin/go /usr/local/bin/gofmt

if command -v apt-get >/dev/null 2>&1; then
    apt-get remove --purge -y "golang-*" || true
    apt-get autoremove -y
    apt-get autoclean -y
fi

# Install
tar -C /usr/local -xzf "$GOLANG_TAR_FILE"

# Add to system path
ln -sf /usr/local/go/bin/* /usr/bin/
ln -sf /usr/local/go/bin/* /usr/local/bin/

# Cleanup
rm -f "$GOLANG_TAR_FILE"

# Print success message
echo ""
echo "Golang version $GOLANG_VERSION installation completed successfully."
echo ""
