#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch dist-amd64 --filter=blob:none --sparse https://github.com/debuerreotype/docker-debian-artifacts
cd docker-debian-artifacts
git sparse-checkout init --cone
git sparse-checkout set bullseye

# Transform

# This sed syntax is GNU sed specific
[ -z $(command -v gsed) ] && GNU_SED=sed || GNU_SED=gsed

${GNU_SED} -i \
    -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/debian\:bullseye/; t" \
    -e "1,// s//ghcr.io\/golden-containers\/debian\:bullseye/" \
    bullseye/backports/Dockerfile

# Build

[ -z "${1:-}" ] && BUILD_LABEL_ARG="" || BUILD_LABEL_ARG=" --label \"${1}\" "

BUILD_PLATFORM=" --platform linux/amd64 "
GCI_URL="ghcr.io/golden-containers"
BUILD_ARGS=" ${BUILD_LABEL_ARG} ${BUILD_PLATFORM} "

docker build bullseye/ --tag ${GCI_URL}/debian:bullseye ${BUILD_ARGS}

docker build bullseye/slim/ --tag ${GCI_URL}/debian:bullseye-slim ${BUILD_ARGS}

docker build bullseye/backports/ --tag ${GCI_URL}/debian:bullseye-backports ${BUILD_ARGS}

# Push

docker push ghcr.io/golden-containers/debian -a
