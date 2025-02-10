#!/bin/bash
set -euo pipefail

# Define variables
CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-linux-x86_64.sh"
CMAKE_INSTALLER="cmake.sh"
CMAKE_PREFIX="/opt/cmake"

# Download
wget -O "$CMAKE_INSTALLER" "$CMAKE_URL"

# Install
mkdir -p "$CMAKE_PREFIX"
chmod +x "$CMAKE_INSTALLER"
sh "$CMAKE_INSTALLER" --prefix="$CMAKE_PREFIX" --skip-license

# Add to system path
ln -s /opt/cmake/bin/* /usr/bin/
ln -s /opt/cmake/bin/* /usr/local/bin/

# Cleanup
rm "$CMAKE_INSTALLER"

# Print success message
echo ""
echo "CMake version $CMAKE_VERSION installation completed successfully."
echo ""
