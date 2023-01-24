#!/bin/bash

set -e

COMPONENT_NAME="github.com/reshnm/landscaper-example"
REPOSITORY_CONTEXT="ghcr.io/reshnm/landscaper-example"

SOURCE_PATH="$(dirname $0)/.."
VERSION=$(cat ${SOURCE_PATH}/VERSION)
COMMIT_SHA=$(git rev-parse HEAD)
EFFECTIVE_VERSION=${VERSION}-${COMMIT_SHA}

COMPONENT_ARCHIVE_PATH="$(mktemp -d)"
BASE_DEFINITION_PATH="${COMPONENT_ARCHIVE_PATH}/component-descriptor.yaml"

echo "> Generate Component Descriptor ${EFFECTIVE_VERSION}"
echo "> Creating base definition"
component-cli ca create "${COMPONENT_ARCHIVE_PATH}" \
    --component-name=${COMPONENT_NAME} \
    --component-version=${EFFECTIVE_VERSION} \
    --repo-ctx=${REPOSITORY_CONTEXT}

echo "> Adding resources"
component-cli ca resources add ${COMPONENT_ARCHIVE_PATH} \
    VERSION=${EFFECTIVE_VERSION} \
    ${SOURCE_PATH}/.landscaper/resources.yaml

echo "> Adding sources"
component-cli ca sources add ${COMPONENT_ARCHIVE_PATH} \
    VERSION=${EFFECTIVE_VERSION} \
    COMMIT_SHA=${COMMIT_SHA} \
    ${SOURCE_PATH}/.landscaper/sources.yaml

echo "> Creating component transport format"
COMPONENT_TRANSPORT_FORMAT_PATH=${COMPONENT_ARCHIVE_PATH}/ctf.tar
component-cli ctf add ${COMPONENT_TRANSPORT_FORMAT_PATH} -f ${COMPONENT_ARCHIVE_PATH}

echo "> Pushing conponent to repository context"
component-cli ctf push --repo-ctx=${REPOSITORY_CONTEXT} ${COMPONENT_TRANSPORT_FORMAT_PATH} 


echo "> Remote Component Descriptor"
component-cli ca remote get ${REPOSITORY_CONTEXT} ${COMPONENT_NAME} ${EFFECTIVE_VERSION}
