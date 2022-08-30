#!/bin/bash

set -e

if [ -z "${CLUSTER_NAME}" ]; then
    >&2 echo "Must set environment variable CLUSTER_NAME"
    exit 1
fi

echo "Updating kubeconfig for cluster ${CLUSTER_NAME}"

aws eks update-kubeconfig --name "${CLUSTER_NAME}"

exec kubectl "$@"
