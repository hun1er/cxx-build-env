# Base image
FROM ubuntu:noble

# Build-time variables
ARG TZ="Europe/Kiev" \
    GNU_VERSION="14" \
    BINUTILS_VERSION \
    CMAKE_VERSION \
    CPPCHECK_VERSION \
    MAKE_VERSION \
    NASM_VERSION \
    APP_DIR="/app"

# Copy scripts to container
COPY "../scripts" "/tmp"

# Container setup
RUN set -eu; \
    \
    # Check if required arguments are provided
    : "${APP_DIR:?}"; \
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
    # Enable 32-bit architecture support
    dpkg --add-architecture i386; \
    \
    # Update system
    apt-get update -y; \
    apt-get upgrade -y; \
    apt-get dist-upgrade -y; \
    \
    # Configure system timezone
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime; \
    echo "$TZ" > /etc/timezone; \
    \
    # Add repositories
    apt-get install -y software-properties-common; \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test; \
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
    gdb \
    gdb-multiarch \
    gdbserver \
    git \
    lcov \
    libtool \
    ltrace \
    m4 \
    make \
    meson \
    pkg-config \
    scons \
    strace \
    subversion \
    gcc-"$GNU_VERSION" gcc-"$GNU_VERSION"-multilib \
    g++"$GNU_VERSION" g++-"$GNU_VERSION"-multilib \
    lib32stdc++6 \
    libc6-dev libc6-dev-i386 \
    libatomic1 libatomic1:i386 \
    libbz2-dev libbz2-dev:i386 \
    libc6-dbg libc6-dbg:i386 \
    libffi-dev libffi-dev:i386 \
    libgdbm-dev libgdbm-dev:i386 \
    liblzma-dev liblzma-dev:i386 \
    libncurses-dev libncurses-dev:i386 \
    libpcre3-dev libpcre32-3 \
    libreadline-dev libreadline-dev:i386 \
    libsqlite3-dev libsqlite3-dev:i386 \
    libssl-dev libssl-dev:i386 \
    libyaml-dev libyaml-dev:i386 \
    zlib1g-dev zlib1g-dev:i386; \
    \
    # Configure alternatives
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-"$GNU_VERSION" 100 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-"$GNU_VERSION"; \
    update-alternatives --set gcc /usr/bin/gcc-"$GNU_VERSION"; \
    \
    # Execute setup scripts
    ./install_ambuild.sh; \
    ./install_cmake.sh; \
    ./install_make.sh; \
    ./install_binutils.sh; \
    ./install_ninja.sh; \
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
