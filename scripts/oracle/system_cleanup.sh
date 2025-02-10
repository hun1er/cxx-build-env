#!/bin/bash
set -euo pipefail

# Clean all cached files from enabled repositories
yum clean all

# Remove unnecessary files
find /usr/share/doc -type f -delete
find /usr/share/info -type f -delete
find /usr/share/man -type f -delete

# Remove cache and logs
rm -rf /root/.cache
rm -rf /usr/share/locale/*
rm -rf /var/cache/*
rm -rf /var/lib/rpm/__db*
rm -rf /var/log/*
rm -rf /var/tmp/*
rm -rf /tmp/*
