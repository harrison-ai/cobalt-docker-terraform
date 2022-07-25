#!/usr/bin/env bash
#
# Publish the current git HEAD to dockerhub, if it matches the given tag.
#

set -e

IMAGE="harrisonai/terraform"

if [  "$#" -ne 1 ]; then
    >&2 echo "Usage: $(basename $0) <tag>"
    exit 1
fi

TAG="$1"

if [ "$(git describe --exact-match --tags HEAD 2> /dev/null )" != "$TAG" ]; then
    >&2 echo "The current HEAD must be tagged as tag: ${TAG}"
    exit 2
fi
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
