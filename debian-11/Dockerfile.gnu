# Base image
FROM debian:bullseye-slim

# Build-time variables
ARG BINUTILS_VERSION \
    CMAKE_VERSION \
    CPPCHECK_VERSION \
    MAKE_VERSION \
    NASM_VERSION \
    APP_DIR="/app" \
    APT_SOURCES_LIST="/etc/apt/sources.list"

# Copy scripts to container
COPY "../scripts" "/tmp"

# Container setup
RUN set -eu; \
    \
    # Check if required arguments are provided
    : "${APP_DIR:?}"; \
    : "${APT_SOURCES_LIST:?}"; \
    : "${BINUTILS_VERSION:?}"; \
    : "${CMAKE_VERSION:?}"; \
    : "${CPPCHECK_VERSION:?}"; \
    : "${MAKE_VERSION:?}"; \
    : "${NASM_VERSION:?}"; \
    \
    # Create working directory and switch to temp directory
    mkdir -p "$APP_DIR"; \
    cd /tmp; \
    \
    # Add repositories
    echo "deb http://deb.debian.org/debian bullseye contrib main non-free" > "$APT_SOURCES_LIST"; \
    echo "deb http://deb.debian.org/debian bullseye-updates contrib main non-free" >> "$APT_SOURCES_LIST"; \
    echo "deb http://deb.debian.org/debian bullseye-backports contrib main non-free" >> "$APT_SOURCES_LIST"; \
    echo "deb http://deb.debian.org/debian-security bullseye-security contrib main non-free" >> "$APT_SOURCES_LIST"; \
    \
    # Enable 32-bit architecture support
    dpkg --add-architecture i386; \
    \
    # Update system
    apt-get update -y; \
    apt-get upgrade -y; \
    apt-get dist-upgrade -y; \
    \
    # Install packages
    apt-get install -y \
    bzip2 \
    cpio \
    curl \
    file \
    gnupg \
    gnupg2 \
    gzip \
    jq \
    procps \
    python3 \
    python3-pip \
    rsync \
    tar \
    unrar \
    unzip \
    wget \
    zip \
    autoconf \
    autoconf-archive \
    automake \
    bison \
    git \
    lcov \
    libtool \
    m4 \
    make \
    meson \
    pkg-config \
    scons \
    subversion \
    gcc gcc-multilib \
    g++ g++-multilib \
    libc-dev libc-dev:i386 \
    libatomic1 libatomic1:i386 \
    libbz2-dev libbz2-dev:i386 \
    libcurl4-openssl-dev libcurl4-openssl-dev:i386 \
    libffi-dev libffi-dev:i386 \
    libgdbm-dev libgdbm-dev:i386 \
    liblzma-dev liblzma-dev:i386 \
    libncurses-dev libncurses-dev:i386 \
    libpcre3-dev libpcre3-dev:i386 \
    libreadline-dev libreadline-dev:i386 \
    libsqlite3-dev libsqlite3-dev:i386 \
    libssl-dev libssl-dev:i386 \
    libyaml-dev libyaml-dev:i386 \
    zlib1g-dev zlib1g-dev:i386; \
    \
    # Execute setup scripts
    ./install_ambuild.sh; \
    ./install_cmake.sh; \
    ./install_make.sh; \
    ./install_binutils.sh; \
    ./install_ninja.sh; \
    ./install_elfkickers.sh; \
    ./install_nasm.sh; \
    ./install_cppcheck.sh; \
    \
    # Configure packages
    ldconfig; \
    git config --global --add safe.directory '*'; \
    \
    # System cleanup
    ./debian/system_cleanup.sh

# Set the working directory
WORKDIR "$APP_DIR"
