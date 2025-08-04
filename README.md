# C/C++ Build Environment

A Docker-based development environment for compiling 32-bit and 64-bit C/C++ applications, pre-configured with modern compilers and build tools.

## Features

- **Modern Toolchain Versions**:
  fresh compiler suites and development tools.

- **Multi-Architecture Support**:
  compile for both x86 (32-bit) and x86_64 (64-bit) targets.

- **Legacy System Compatibility**:
  the **Oracle Linux 7** image comes with **glibc-2.17**, making it a suitable environment for compiling applications that need to run on older Linux distributions.

|  Distribution  | glibc | Binutils | Make  | CMake  | Ninja  |  GCC   | Clang  |
|----------------|-------|----------|-------|--------|--------|--------|--------|
| **Oracle Linux 7** | 2.17  |   2.44   | 4.4.1 | 3.31.8 | 1.13.1 | 15.1.0 |   -    |
| **Ubuntu 24.04**   | 2.39  |   2.44   | 4.4.1 | 3.31.8 | 1.13.1 | 14.2.0 | 20.1.8 |

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
Specify the base Linux distribution for the Docker image (e.g., `oracle-7`, `ubuntu-24.04`).

- `-c, --compiler <name>`<br />
Specify the compiler to include in the Docker image:
  - `gnu`: GNU Compiler Collection (GCC)
  - `clang`: Clang/LLVM
  - `all`: Build images for each compiler available in the specified distribution.

- `-t, --tag <tag>`<br />
Specify a custom Docker image tag (optional).<br />

- `-h, --help`<br />
Display the help message.

### Examples

Build a Docker image for Ubuntu 24.04 LTS with the GNU compiler:

```console
./build.sh --distro ubuntu-24.04 --compiler gnu
```

Build a Docker image for Oracle 7 with the GNU compiler and a custom tag:

```console
./build.sh -d oracle-7 -c gnu -t my-custom-tag
```

Build Docker images for all available compilers on Ubuntu 24.04 LTS:

```console
./build.sh -d ubuntu-24.04
```

## Prebuilt Images

Ready-to-use images are available on Docker Hub:

- **Ubuntu 24.04 Images**:
  - 🐂 [GNU](https://hub.docker.com/repository/docker/hun1er/ubuntu-24.04-cxx-build-env-gnu)
  - 🐉 [Clang/LLVM](https://hub.docker.com/repository/docker/hun1er/ubuntu-24.04-cxx-build-env-clang)

- **Oracle Linux 7 Images**:
  - 🐂 [GNU](https://hub.docker.com/repository/docker/hun1er/oracle-7-cxx-build-env-gnu)

## License

This project is licensed under the [MIT License](LICENSE).

### Third-Party Licenses

This project uses third-party software and tools, each distributed under their respective licenses:
- **Oracle Linux**: distributed under the Oracle Linux End User License Agreement (EULA). See [Oracle Linux EULA](https://oss.oracle.com/ol7/EULA).
- **GCC**: distributed under the GNU GPL. See [GCC Licensing](https://gcc.gnu.org/onlinedocs/gcc/Copying.html).
- **Clang/LLVM**: distributed under the Apache 2.0 License with LLVM Exceptions. See [LLVM Licensing](https://llvm.org/docs/DeveloperPolicy.html).
