#!/bin/bash
set -eu

# Directory with Dockerfiles
DOCKERFILES_DIR="./debian-11"

# Available images
declare -A images=(
    ["GNU"]="${DOCKERFILES_DIR}/Dockerfile.gnu"
    ["Clang"]="${DOCKERFILES_DIR}/Dockerfile.clang"
    ["Intel"]="${DOCKERFILES_DIR}/Dockerfile.intel"
)

# Ordered list of image names for guaranteed build sequence
order=("GNU" "Clang" "Intel")

# Color codes for messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No color

# Variables for command-line options
selected_image=""
custom_tag=""
build_all=false

# Print a color-coded message
print_message() {
    echo -e "${1}${2}${NC}"
}

# Display help information
print_help() {
    cat << EOF
Usage: $0 [options]

Options:
  -i, --image <name>    Specify the image to build (e.g., 'GNU', 'Clang', 'Intel').
  -t, --tag <tag>       Specify the custom tag for the Docker image.
  -a, --all             Build all images with default tags.
  -h, --help            Show this help message and exit.

If no options are provided, the script will run in interactive mode.
EOF
}

# Build the specified image
build_image() {
    local name="$1"
    local dockerfile="$2"
    local tag="${3:-hun1er/build-env-${name,,}}"

    print_message "$GREEN" "Building ${name} image with tag '${tag}' ..."
    docker build --file "${dockerfile}" --tag "${tag}" .
    print_message "$GREEN" "'${tag}' was successfully built."
}

# Process the tag for building
process_build() {
    local name="$1"
    local dockerfile="${images[$name]}"
    local tag="${2:-hun1er/build-env-${name,,}}"

    build_image "$name" "$dockerfile" "$tag"
}

# Prompt for custom tag and build image
prompt_and_build() {
    local name="$1"
    local default_tag="hun1er/build-env-${name,,}"

    read -rp "Enter tag name for the ${name} image (default: ${default_tag}): " tag_name
    tag_name="${tag_name:-$default_tag}"

    process_build "$name" "$tag_name"
}

# Interactive mode to select and build images
interactive_mode() {
    print_message "$YELLOW" "Select the image to build:"

    echo "0) All images"
    for i in "${!order[@]}"; do
        echo "$((i+1))) ${order[i]}"
    done

    read -rp "Enter the option number [0-${#order[@]}] (default: all): " choice
    choice="${choice:-0}"

    if [[ "$choice" -eq 0 ]]; then
        # Build all images with prompted tag names
        for name in "${order[@]}"; do
            prompt_and_build "$name"
        done
    elif ((choice >= 1 && choice <= ${#order[@]})); then
        # Build selected image with prompted tag name
        local name="${order[$((choice-1))]}"
        prompt_and_build "$name"
    else
        print_message "$RED" "Invalid option. Please enter a number between 0 and ${#order[@]}."
        exit 1
    fi
}

# Parse command-line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -i|--image)
            selected_image="$2"
            shift 2
            ;;
        -t|--tag)
            custom_tag="$2"
            shift 2
            ;;
        -a|--all)
            build_all=true
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            print_message "$RED" "Unknown option: $1"
            print_help
            exit 1
            ;;
    esac
done

# Build images based on options
if [[ "$build_all" == true ]]; then
    for name in "${order[@]}"; do
        process_build "$name"
    done
elif [[ -n "$selected_image" ]]; then
    if [[ -n ${images["$selected_image"]+x} ]]; then
        process_build "$selected_image" "$custom_tag"
    else
        print_message "$RED" "Invalid image name '${selected_image}'. Available options are: ${!images[*]}"
        exit 1
    fi
else
    interactive_mode
fi

print_message "$GREEN" "Build process completed."
