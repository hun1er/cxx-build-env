#
# Stage 1: Build the builder image
#

# Build-time global variables
ARG DEVTOOLSET_DIR="/home/devtoolset"

# Base image
FROM hun1er/oracle-7-cxx-build-env-gnu AS builder

# Build-time variables
ARG BINUTILS_VERSION \
    CMAKE_VERSION \
    DEVTOOLSET_DIR \
    GCC_VERSION \
    MAKE_VERSION \
    BUILDER_DEVTOOLSET_VERSION="15" \
    BINUTILS_PREFIX="$DEVTOOLSET_DIR/root/usr" \
    GCC_PREFIX="$BINUTILS_PREFIX" \
    MAKE_PREFIX="$BINUTILS_PREFIX"

# Copy scripts to container
COPY "../scripts" "/tmp"

# Container setup
RUN set -eu; \
    \
    # Check if required arguments are provided
    : "${BINUTILS_VERSION:?}"; \
    : "${CMAKE_VERSION:?}"; \
    : "${DEVTOOLSET_DIR:?}"; \
    : "${GCC_VERSION:?}"; \
    : "${MAKE_VERSION:?}"; \
    : "${BUILDER_DEVTOOLSET_VERSION:?}"; \
    : "${BINUTILS_PREFIX:?}"; \
    : "${GCC_PREFIX:?}"; \
    : "${MAKE_PREFIX:?}"; \
    \
    # Switch to temp directory
    cd /tmp; \
    \
    # Update system
    yum clean all; \
    yum update -y; \
    \
    # Create copy devtoolset directory structure
    cd "/opt/rh/devtoolset-$BUILDER_DEVTOOLSET_VERSION"; \
    find . \( -type d -o \( -type l -a -xtype d \) \) -print0 | cpio -0 -pdm "$DEVTOOLSET_DIR"; \
    cd "$DEVTOOLSET_DIR/root/usr"; \
    rm -f "tmp"; \
    ln -s "../var/tmp" "tmp"; \
    cp "/opt/rh/devtoolset-$BUILDER_DEVTOOLSET_VERSION/enable" "$DEVTOOLSET_DIR"; \
    cd /tmp; \
    \
    # Enable devtoolset
    . "/opt/rh/devtoolset-$BUILDER_DEVTOOLSET_VERSION/enable"; \
    \
    # Enable python 3.8
    . /opt/rh/rh-python38/enable; \
    \
    # Execute setup scripts
    ./install_make.sh; \
    ./install_binutils.sh; \
    ./install_gcc.sh; \
    \
    # System cleanup
    ./oracle/system_cleanup.sh

#
# Stage 2: Build the final image
#

# Base image
FROM oraclelinux:7-slim

# Build-time variables
ARG CMAKE_VERSION \
    CPPCHECK_VERSION \
    DEVTOOLSET_DIR \
    NASM_VERSION \
    APP_DIR="/app"

# Environment variables
ENV RUNTIME_DEVTOOLSET_VERSION="15"

# Copy devtoolset from builder image to final image
COPY --from=builder "$DEVTOOLSET_DIR" "/opt/rh/devtoolset-$RUNTIME_DEVTOOLSET_VERSION"

# Copy scripts to container
COPY "../scripts" "/tmp"

# Container setup
RUN set -eu; \
    \
    # Check if required arguments are provided
    : "${APP_DIR:?}"; \
    : "${CMAKE_VERSION:?}"; \
    : "${CPPCHECK_VERSION:?}"; \
    : "${DEVTOOLSET_DIR:?}"; \
    : "${NASM_VERSION:?}"; \
    : "${RUNTIME_DEVTOOLSET_VERSION:?}"; \
    \
    # Create working directory and switch to temp directory
    mkdir -p "$APP_DIR"; \
    cd /tmp; \
    \
    # Add repositories
    yum clean all; \
    yum install -y \
    mysql-release-el7 \
    oracle-epel-release-el7 \
    oracle-golang-release-el7 \
    oracle-nodejs-release-el7 \
    oracle-php-release-el7 \
    oracle-release-el7 \
    oracle-software-release-el7 \
    oracle-softwarecollection-release-el7 \
    oraclelinux-developer-release-el7 \
    oraclelinux-release-el7 \
    https://archives.fedoraproject.org/pub/archive/epel/7/x86_64/Packages/e/epel-release-7-14.noarch.rpm \
    https://vault.ius.io/el7/x86_64/packages/i/ius-release-2-1.el7.ius.noarch.rpm; \
    \
    # Fix IUS repository URLs
    sed -i 's|repo.ius.io/7|vault.ius.io/el7|g' /etc/yum.repos.d/ius*.repo; \
    \
    # Enable repositories
    yum install -y \
    scl-utils \
    yum-utils; \
    yum-config-manager --enable ol7_addons; \
    yum-config-manager --enable ol7_optional_latest; \
    \
    # Update system
    yum clean all; \
    yum update -y; \
    \
    # Enable devtoolset
    sed -i "s/devtoolset-[0-9]\+/devtoolset-$RUNTIME_DEVTOOLSET_VERSION/g" "/opt/rh/devtoolset-$RUNTIME_DEVTOOLSET_VERSION/enable"; \
    echo "/opt/rh" > "/etc/scl/prefixes/devtoolset-$RUNTIME_DEVTOOLSET_VERSION"; \
    . "/opt/rh/devtoolset-$RUNTIME_DEVTOOLSET_VERSION/enable"; \
    \
    # Install packages
    yum install -y \
    autoconf \
    automake \
    bzip2 \
    bzip2-devel \
    bzip2-devel.i686 \
    coreutils \
    cpio \
    curl \
    diffutils \
    file \
    git236 \
    git236-core \
    git236-cvs \
    git236-subtree \
    git236-svn \
    glibc \
    glibc-common \
    glibc-devel \
    glibc-devel.i686 \
    glibc-headers \
    glibc-static \
    glibc-static.i686 \
    glibc-utils \
    glibc.i686 \
    grep \
    gzip \
    jq \
    libffi-devel \
    libffi-devel.i686 \
    libgomp \
    libgomp.i686 \
    libicu \
    libicu.i686 \
    libmpc \
    libmpc.i686 \
    libsmartcols \
    libsmartcols.i686 \
    libyaml-devel \
    libyaml-devel.i686 \
    lz4 \
    m4 \
    meson \
    mpfr \
    mpfr-devel \
    mpfr-devel.i686 \
    mpfr.i686 \
    ncurses-devel \
    ncurses-devel.i686 \
    openssl-devel \
    openssl-devel.i686 \
    pcre-devel \
    pcre-devel.i686 \
    perl \
    pkgconfig \
    procps-ng-devel \
    procps-ng-devel.i686 \
    rh-python38 \
    rh-python38-python-pip \
    readline-devel \
    readline-devel.i686 \
    rsync \
    scons \
    sqlite-devel \
    sqlite-devel.i686 \
    subversion \
    tar \
    unzip \
    wget \
    xz \
    zip \
    zlib-devel \
    zlib-devel.i686; \
    \
    # Enable python 3.8
    . /opt/rh/rh-python38/enable; \
    \
    # Execute setup scripts
    ./install_ambuild.sh; \
    ./install_cmake.sh; \
    ./install_ninja.sh; \
    ./install_nasm.sh; \
    ./install_cppcheck.sh; \
    \
    # Configure packages
    ldconfig; \
    git config --global --add safe.directory '*'; \
    \
    # Install the entrypoint script
    mv -f ./oracle/entrypoint.sh /usr/local/bin/; \
    chmod +x /usr/local/bin/entrypoint.sh; \
    \
    # System cleanup
    ./oracle/system_cleanup.sh

# Set up the entry point
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Set the default command
CMD ["bash"]

# Set the working directory
WORKDIR "$APP_DIR"
