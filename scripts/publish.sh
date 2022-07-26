#!/usr/bin/env bash
#
# Publish the current git HEAD to dockerhub.
#

set -e

IMAGE="harrisonai/terraform"

if [  "$#" -ne 1 ]; then
    >&2 echo "Usage: $(basename $0) <tag>"
    exit 1
fi

TAG="$1"

if git diff --exit-code > /dev/null; then true; else 
    >&2 echo "Refusing to publish from a working dir with unstaged changes"
    exit 3
fi
if git diff --cached --exit-code > /dev/null; then true; else
    >&2 echo "Refusing to publish from a working dir with uncommited changes"
    exit 4
fi

echo "Building image ${IMAGE} with tags: '${TAG}', 'latest'"

docker build -t "${IMAGE}:latest" -t "${IMAGE}:${TAG}" .

docker push "${IMAGE}:latest"
docker push "${IMAGE}:${TAG}"
