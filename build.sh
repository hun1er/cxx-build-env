#!/bin/bash
set -euo pipefail

# Define variables
readonly BINUTILS_VERSION="2.44"
readonly CLANG_VERSION="19"
readonly CMAKE_VERSION="3.31.6"
readonly CPPCHECK_VERSION="2.17.1"
readonly GCC_VERSION="14.2.0"
readonly MAKE_VERSION="4.4.1"
readonly NASM_VERSION="2.16.03"

# Available compilers for each distribution
declare -A AVAILABLE_COMPILERS=(
    ["debian-11"]="gnu clang intel"
    ["oracle-7"]="gnu"
    ["ubuntu-24.04"]="gnu clang intel"
)

# Global options with default values
DISTRO=""
COMPILER=""
CUSTOM_TAG=""

# ANSI color codes for output messages
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m' # No Color

# Log an informational message
print_info() {
    echo -e "${GREEN}[INFO]:$NC $1"
}

# Log a warning message
print_warning() {
    echo -e "${YELLOW}[WARNING]:$NC $1"
}

# Log an error message
print_error() {
    echo -e "${RED}[ERROR]:$NC $1" >&2
}

# Show help message
print_help() {
    cat << EOF
Usage: $0 [options]

Options:
  -d, --distro <name>
        Specify the Linux distribution on which the Docker image will be based (e.g., 'oracle-7', 'debian-11').

  -c, --compiler <name>
        Specify the compiler to include in the Docker image.
        If a specific compiler is provided (e.g., 'gnu', 'clang', or 'intel'),
        a Docker image will be built that contains that compiler.
        If 'all' is specified, Docker images will be built for each compiler
        available in the specified distribution, using default tags.

  -t, --tag <tag>
        Specify a custom tag for the Docker image (if not provided, a default tag is used).

  -h, --help
        Show this help message and exit.
EOF
}

# Build a Docker image based on a given distro with a specific compiler and tag
build_image() {
    local distro="$1"
    local compiler="$2"
    local tag="$3"
    local dockerfile="$distro/Dockerfile.$compiler"

    print_info \
        "Building Docker image based on distro $distro with compiler $compiler."

    docker build \
        --build-arg BINUTILS_VERSION="$BINUTILS_VERSION" \
        --build-arg CLANG_VERSION="$CLANG_VERSION" \
        --build-arg CMAKE_VERSION="$CMAKE_VERSION" \
        --build-arg CPPCHECK_VERSION="$CPPCHECK_VERSION" \
        --build-arg GCC_VERSION="$GCC_VERSION" \
        --build-arg MAKE_VERSION="$MAKE_VERSION" \
        --build-arg NASM_VERSION="$NASM_VERSION" \
        --file "$dockerfile" --tag "$tag" .
}

# Build Docker images with all available compilers for the specified distribution
build_all_images() {
    local distro="$1"
    local available="${AVAILABLE_COMPILERS[$distro]-}"

    if [[ -z "$available" ]]; then
        print_error "No available compilers for distribution: $distro"
        exit 1
    fi

    for compiler in $available; do
        local tag="hun1er/$distro-cxx-build-env-$compiler"
        build_image "$distro" "$compiler" "$tag"
    done
}

# Parse command-line options
parse_options() {
    local parsed

    parsed=$(getopt -o d:c:t:h --long distro:,compiler:,tag:,help -n "$0" -- "$@" 2>/dev/null)
    eval set -- "$parsed"

    while true; do
        case "$1" in
            -d|--distro)
                DISTRO="$2"
                shift 2
                ;;
            -c|--compiler)
                COMPILER="$2"
                shift 2
                ;;
            -t|--tag)
                CUSTOM_TAG="$2"
                shift 2
                ;;
            -h|--help)
                print_help
                exit 0
                ;;
            --)
                shift
                break
                ;;
            *)
                print_error "Unexpected option: $1"
                exit 1
                ;;
        esac
    done
}

# Validate required options
validate_options() {
    # If compiler is not specified, default to "all"
    if [[ -z "$COMPILER" ]]; then
        COMPILER="all"
        print_info "No compiler specified. Building images with all available compilers."
    fi

    # Normalize compiler name: replace 'gcc' with 'gnu' for compatibility
    if [[ "$COMPILER" == "gcc" ]]; then
        COMPILER="gnu"
    fi

    # Check if distribution is specified
    if [[ -z "$DISTRO" ]]; then
        print_error "Distribution (--distro) must be specified."
        exit 1
    fi

    # Check if distribution is supported
    if [[ ! -v AVAILABLE_COMPILERS[$DISTRO] ]]; then
        print_error "Unsupported distribution: $DISTRO"

        local distros=()
        for key in "${!AVAILABLE_COMPILERS[@]}"; do
            distros+=("$key")
        done
        print_info "Available distributions: ${distros[*]}"

        exit 1
    fi

    # Check if compiler is supported for the distribution
    if [[ "$COMPILER" != "all" && ! " ${AVAILABLE_COMPILERS[$DISTRO]-} " == *" $COMPILER "* ]]; then
        print_error "The $COMPILER compiler is not supported for distribution $DISTRO"
        print_info "Supported compilers: ${AVAILABLE_COMPILERS[$DISTRO]}"
        exit 1
    fi

    # Check if custom tag is provided with 'all' compilers
    if [[ "$COMPILER" == "all" && -n "$CUSTOM_TAG" ]]; then
        print_warning "Custom tag provided with 'all' compilers will be ignored. Default tags will be used."
    fi
}

# Main function to coordinate script execution
main() {
    parse_options "$@"
    validate_options

    if [[ "$COMPILER" == "all" ]]; then
        build_all_images "$DISTRO"
    else
        local tag="${CUSTOM_TAG:-hun1er/$DISTRO-cxx-build-env-$COMPILER}"
        build_image "$DISTRO" "$COMPILER" "$tag"
    fi
}

# Execute the main function with all command-line arguments
main "$@"
