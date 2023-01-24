#!/bin/bash

set -e

COMPONENT_NAME="github.com/reshnm/landscaper-example"
REPOSITORY_CONTEXT="ghcr.io/reshnm/landscaper-example"

SCRIPT_PATH="$(dirname $0)"
SOURCE_PATH="$(dirname $0)/.."
VERSION=$(cat ${SOURCE_PATH}/VERSION)
COMMIT_SHA=$(git rev-parse HEAD)
EFFECTIVE_VERSION=${VERSION}-${COMMIT_SHA}

export COMPONENT_NAME
export REPOSITORY_CONTEXT
export EFFECTIVE_VERSION

cat ${SCRIPT_PATH}/installation-template.yaml | envsubst
