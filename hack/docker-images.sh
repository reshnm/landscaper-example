#!/bin/bash

set -e

REPOSITORY_CONTEXT="ghcr.io/reshnm/landscaper-example"
IMAGE_NAME="podinfo"

SOURCE_PATH="$(dirname $0)/.."
VERSION=$(cat ${SOURCE_PATH}/VERSION)
EFFECTIVE_VERSION=${VERSION}-$(git rev-parse HEAD)

docker build --platform amd64 -t "${REPOSITORY_CONTEXT}/${IMAGE_NAME}:${EFFECTIVE_VERSION}" -f ${SOURCE_PATH}/Dockerfile .
docker push "${REPOSITORY_CONTEXT}/${IMAGE_NAME}:${EFFECTIVE_VERSION}"
