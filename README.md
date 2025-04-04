# C/C++ Build Environment

A Docker-based development environment for compiling 32-bit and 64-bit C/C++ applications, pre-configured with modern compilers and build tools.

## Features

- **Modern Toolchain Versions**:
  fresh compiler suites and development tools.

- **Multi-Architecture Support**:
  compile for both x86 (32-bit) and x86_64 (64-bit) targets.

- **Legacy System Compatibility**:
  the **Oracle Linux 7** image comes with **glibc-2.17**, making it a suitable environment for compiling applications that need to run on older Linux distributions.

|  Distribution  | glibc | Binutils | Make  | CMake  | Ninja  |  GCC   | Clang  | Intel oneAPI |
|----------------|-------|----------|-------|--------|--------|--------|--------|--------------|
| **Debian 11**      | 2.31  |   2.44   | 4.4.1 | 3.31.6 | 1.12.2 | 10.2.1 | 19.1.7 |   2024.2.1   |
| **Oracle Linux 7** | 2.17  |   2.44   | 4.4.1 | 3.31.6 | 1.12.2 | 14.2.0 |   -    |      -       |
| **Ubuntu 24.04**   | 2.39  |   2.44   | 4.4.1 | 3.31.6 | 1.12.2 | 14.2.0 | 19.1.7 |   2024.2.1   |

## Building Images

### Prerequisites
- [Docker](https://www.docker.com) installed on your machine.
- A Unix-like shell (Linux, macOS, or WSL on Windows) to run the build script.

### Usage
The build process is managed via the `build.sh` script:

```console
./build.sh [options]
```

To build the Docker images, run the build.sh with the following options:

- `-d, --distro <name>`<br />
Specify the base Linux distribution for the Docker image (e.g., `oracle-7`, `debian-11`).

- `-c, --compiler <name>`<br />
Specify the compiler to include in the Docker image:
  - `gnu`: GNU Compiler Collection (GCC)
  - `clang`: Clang/LLVM
  - `intel`: Intel oneAPI DPC++/C++ Compiler
  - `all`: Build images for each compiler available in the specified distribution.

- `-t, --tag <tag>`<br />
Specify a custom Docker image tag (optional).<br />

- `-h, --help`<br />
Display the help message.

### Examples

Build a Docker image for Debian 11 with the GNU compiler:

```console
./build.sh --distro debian-11 --compiler gnu
```

Build a Docker image for Oracle 7 with the GNU compiler and a custom tag:

```console
./build.sh -d oracle-7 -c gnu -t my-custom-tag
```

Build Docker images for all available compilers on Debian 11:

```console
./build.sh -d debian-11
```

## Prebuilt Images

Ready-to-use images are available on Docker Hub:

- **Debian 11 Images**:
  - 🐂 [GNU](https://hub.docker.com/repository/docker/hun1er/debian-11-cxx-build-env-gnu)
  - 🐉 [Clang/LLVM](https://hub.docker.com/repository/docker/hun1er/debian-11-cxx-build-env-clang)
  - 🔷 [Intel oneAPI](https://hub.docker.com/repository/docker/hun1er/debian-11-cxx-build-env-intel)

- **Ubuntu 24.04 Images**:
  - 🐂 [GNU](https://hub.docker.com/repository/docker/hun1er/ubuntu-24.04-cxx-build-env-gnu)
  - 🐉 [Clang/LLVM](https://hub.docker.com/repository/docker/hun1er/ubuntu-24.04-cxx-build-env-clang)
  - 🔷 [Intel oneAPI](https://hub.docker.com/repository/docker/hun1er/ubuntu-24.04-cxx-build-env-intel)

- **Oracle Linux 7 Images**:
  - 🐂 [GNU](https://hub.docker.com/repository/docker/hun1er/oracle-7-cxx-build-env-gnu)

## License

This project is licensed under the [MIT License](LICENSE).

### Third-Party Licenses

This project uses third-party software and tools, each distributed under their respective licenses:
- **Debian**: distributed under the GNU GPL and other free software licenses. See [Debian Licensing](https://www.debian.org/legal/licenses).
- **Oracle Linux**: distributed under the Oracle Linux End User License Agreement (EULA). See [Oracle Linux EULA](https://oss.oracle.com/ol7/EULA).
- **GCC**: distributed under the GNU GPL. See [GCC Licensing](https://gcc.gnu.org/onlinedocs/gcc/Copying.html).
- **Clang/LLVM**: distributed under the Apache 2.0 License with LLVM Exceptions. See [LLVM Licensing](https://llvm.org/docs/DeveloperPolicy.html).
- **Intel oneAPI**: distributed under the Intel End User License Agreement (EULA). See [Intel Licensing](https://www.intel.com/content/www/us/en/developer/articles/license/end-user-license-agreement.html).
