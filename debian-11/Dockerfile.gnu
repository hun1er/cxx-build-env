# Base image
FROM debian:bullseye-slim

# Environment variables
ENV APP_DIR="/app"
ENV APT_SOURCES_LIST="/etc/apt/sources.list"
ENV CMAKE_VERSION="3.29.8"
ENV CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh"
ENV CPPCHECK_VERSION="2.15.0"
ENV CPPCHECK_URL="https://github.com/danmar/cppcheck/archive/${CPPCHECK_VERSION}.tar.gz"

# Container setup
RUN set -eu; \
    # Create working directory and switch to temp directory
    mkdir -p "${APP_DIR}"; \
    cd /tmp; \
    \
    # Add repositories
    echo "deb http://deb.debian.org/debian bullseye contrib main non-free" > "${APT_SOURCES_LIST}"; \
    echo "deb http://deb.debian.org/debian bullseye-updates contrib main non-free" >> "${APT_SOURCES_LIST}"; \
    echo "deb http://deb.debian.org/debian-security bullseye-security contrib main non-free" >> "${APT_SOURCES_LIST}"; \
    \
    # Enable 32-bit architecture support
    dpkg --add-architecture i386; \
    \
    # Update system
    apt update -y; \
    apt upgrade -y; \
    apt dist-upgrade -y; \
    \
    # Install packages
    apt install -y \
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
    libtool \
    m4 \
    make \
    meson \
    nasm \
    ninja-build \
    pkg-config \
    scons \
    subversion \
    yasm \
    gcc gcc-multilib \
    g++ g++-multilib \
    libc-dev libc-dev:i386 \
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
    # Install CMake
    mkdir -p /opt/cmake; \
    wget -O "cmake.sh" "${CMAKE_URL}"; \
    chmod +x "cmake.sh"; \
    sh "cmake.sh" --prefix=/opt/cmake --skip-license; \
    rm "cmake.sh"; \
    ln -s /opt/cmake/bin/* /usr/bin/; \
    ln -s /opt/cmake/bin/* /usr/local/bin/; \
    \
    # Install AMbuild
    git clone https://github.com/alliedmodders/ambuild; \
    pip install ./ambuild; \
    rm -rf ambuild; \
    \
    # Install ELFkickers
    git clone https://github.com/BR903/ELFkickers.git; \
    cd ELFkickers; \
    make --jobs="$(nproc)"; \
    make install; \
    cd ..; \
    rm -rf ELFkickers; \
    \
    # Install Cppcheck
    wget -O "cppcheck.tar.gz" "${CPPCHECK_URL}"; \
    tar -xf "cppcheck.tar.gz"; \
    cd cppcheck-"${CPPCHECK_VERSION}"; \
    mkdir -p /usr/local/share/Cppcheck; \
    cp -r cfg /usr/local/share/Cppcheck; \
    mkdir build; \
    cd build; \
    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_GUI=OFF -DHAVE_RULES=ON -DUSE_MATCHCOMPILER=ON ..; \
    cmake --build . --parallel "$(nproc)"; \
    make install; \
    cd ../../; \
    rm -rf cppcheck-"${CPPCHECK_VERSION}"; \
    \
    # Configure packages
    ldconfig; \
    git config --global --add safe.directory '*'; \
    \
    # System cleanup
    apt autoremove -y --purge; \
    apt autoclean -y; \
    apt clean -y; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /var/cache/*; \
    rm -rf /var/log/*; \
    rm -rf /tmp/*;

WORKDIR "${APP_DIR}"
