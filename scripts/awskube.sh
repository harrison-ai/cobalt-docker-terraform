#!/bin/bash

set -e

echo "Updating kubeconfig for cluster ${CLUSTER_NAME}"

aws eks update-kubeconfig --name "${CLUSTER_NAME}"

exec kubectl "$@"
