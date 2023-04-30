#!/bin/bash
source "../build-functions.sh"
source "../build-config.sh"

DOCKER_IMAGE_NAME="daniel156161/code-server-teleport"

function run_docker_container {
  echo "Running..."
  docker run -d \
    -p 8080:8080 \
    -p 2222:22 \
    -e TZ="Europe/Vienna" \
    -v "$PWD/data:/data" \
    -v "$PWD/teleport/teleport.yaml:/etc/teleport.yaml" \
    -v "$PWD/teleport/data:/var/lib/teleport" \
    "$DOCKER_IMAGE_NAME:$GIT_BRANCH"
}

case "$1" in
  run)
    run_docker_container
    ;;
  build)
    build_docker_image "$DOCKER_IMAGE_NAME:$GIT_BRANCH"
    ;;
  *)
    echo "Usage: $0 {run|build}"
    exit 1
    ;;
esac
