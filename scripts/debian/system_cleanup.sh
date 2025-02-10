#!/bin/bash
set -euo pipefail

# Remove unnecessary packages
apt-get autoremove -y --purge
apt-get autoclean -y
apt-get clean -y

# Remove unnecessary files
find /usr/share/doc -type f -delete
find /usr/share/info -type f -delete
find /usr/share/man -type f -delete

# Remove cache and logs
rm -rf /root/.cache
rm -rf /usr/share/locale/*
rm -rf /var/cache/*
rm -rf /var/lib/apt/lists/*
rm -rf /var/log/*
rm -rf /var/tmp/*
rm -rf /tmp/*
