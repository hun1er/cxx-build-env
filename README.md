# C/C++ Build Environment

Dockerfiles for setting up a C/C++ build environment using three major compilers:

- [**GNU**](https://hub.docker.com/repository/docker/hun1er/build-env-gnu/) ([Dockerfile.gnu](debian-11/Dockerfile.gnu))
- [**Clang**](https://hub.docker.com/repository/docker/hun1er/build-env-clang/) ([Dockerfile.clang](debian-11/Dockerfile.clang))
- [**Intel OneAPI**](https://hub.docker.com/repository/docker/hun1er/build-env-intel/) ([Dockerfile.intel](debian-11/Dockerfile.intel))

Each Docker image includes essential build tools and libraries, with compilers configured to support multiple architectures, allowing for the building of both 32-bit and 64-bit binaries.

## Build

To build the Docker images, run the `build.sh` script with the following options:

```bash
./build.sh [options]
```

- `-i`, `--image <name>`
  Build a specific image by compiler name. Available names are `GNU`, `Clang`, and `Intel`.

- `-t`, `--tag <tag>`
  Specify a custom tag for the Docker image.

- `-a`, `--all`
  Build all images with default tags.

- `-h`, `--help`
  Display the help message for the script.

If no options are specified, `build.sh` enters **interactive mode**, prompting you to select images and specify tags.

### Examples

- To build the GNU image with a custom tag:
```bash
./build.sh -i GNU -t my-custom-tag
```

- To build all images with default tags:
```bash
./build.sh --all
```

- To run in interactive mode:
```bash
./build.sh
```
