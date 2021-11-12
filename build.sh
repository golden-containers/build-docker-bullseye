#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

GCI_URL="ghcr.io/golden-containers"

# Checkout upstream

git clone --depth 1 --branch dist-amd64 --filter=blob:none --sparse https://github.com/debuerreotype/docker-debian-artifacts
cd docker-debian-artifacts
git sparse-checkout init --cone
git sparse-checkout set bullseye

# Transform

GCI_REGEX_URL=$(echo ${GCI_URL} | sed 's/\//\\\//g')

# This sed syntax is GNU sed specific
[ -z $(command -v gsed) ] && GNU_SED=sed || GNU_SED=gsed

${GNU_SED} -i \
    -e "1 s/FROM.*/FROM ${GCI_REGEX_URL}\/debian\:bullseye/; t" \
    -e "1,// s//FROM ${GCI_REGEX_URL}\/debian\:bullseye/" \
    bullseye/backports/Dockerfile

# Build

[ -z "${1:-}" ] && BUILD_LABEL_ARG="" || BUILD_LABEL_ARG=" --label \"${1}\" "

BUILD_PLATFORM=" --platform linux/amd64 "
BUILD_ARGS=" ${BUILD_LABEL_ARG} ${BUILD_PLATFORM} "

docker build bullseye/ ${BUILD_ARGS} \
    --tag ${GCI_URL}/debian:bullseye 
    
docker build bullseye/slim/ ${BUILD_ARGS} \
    --tag ${GCI_URL}/debian:bullseye-slim 
    
docker build bullseye/backports/ ${BUILD_ARGS} \
    --tag ${GCI_URL}/debian:bullseye-backports 
    
# Push

docker push ${GCI_URL}/debian -a
