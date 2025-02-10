#!/bin/bash
set -euo pipefail

# Define variables
INTEL_URL="${INTEL_URL:-https://registrationcenter-download.intel.com/akdlm/IRC_NAS/74587994-3c83-48fd-b963-b707521a63f4/l_dpcpp-cpp-compiler_p_2024.2.1.79_offline.sh}"
INTEL_INSTALLER="dpcpp-cpp-compiler_offline.sh"

# Download
wget -O "$INTEL_INSTALLER" "$INTEL_URL"

# Install
chmod +x "$INTEL_INSTALLER"
bash "$INTEL_INSTALLER" \
    --remove-extracted-files yes \
    -a --cli --silent \
    --action install \
    --eula accept \
    --intel-sw-improvement-program-consent decline

# Cleanup
rm "$INTEL_INSTALLER"

# Print success message
echo ""
echo "Intel oneAPI DPC++/C++ Compiler installation completed successfully."
echo ""
