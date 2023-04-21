#!/bin/bash

DOCKER_IMAGE_NAME="daniel156161/code-server-teleport"
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

build_docker_image() {
  TAG="$1"

  echo "Building..."
  docker buildx build --push \
    --platform linux/amd64 \
    --tag "$DOCKER_IMAGE_NAME:$TAG" .
}

run_docker_container() {
  echo "Running..."
  docker run -d \
    -p 8080:8080 \
    -p 2222:22 \
    -e TZ="Europe/Vienna" \
    -v "$PWD/data:/data" \
    -v "$PWD/teleport/teleport.yaml:/etc/teleport.yaml" \
    -v "$PWD/teleport/data:/var/lib/teleport" \
    "$DOCKER_IMAGE_NAME":"$GIT_BRANCH"
}

if [ "$GIT_BRANCH" == "main" ]; then
  GIT_BRANCH="latest"
fi

case "$1" in
  run)
    run_docker_container
    ;;
  build)
    build_docker_image "$GIT_BRANCH"
    ;;
  upload)
    build_docker_image "$GIT_BRANCH"
    docker push "$DOCKER_IMAGE_NAME:$GIT_BRANCH"
    ;;
  *)
    echo "Usage: $0 {build|upload}"
    exit 1
    ;;
esac
