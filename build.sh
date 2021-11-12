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

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/debian\:bullseye/; t" -e "1,// s//ghcr.io\/golden-containers\/debian\:bullseye/" bullseye/backports/Dockerfile

# Build

docker build bullseye/ --tag ghcr.io/golden-containers/debian:bullseye --label ${1:-DEBUG=TRUE}

docker build bullseye/slim/ --tag ghcr.io/golden-containers/debian:bullseye-slim --label ${1:-DEBUG=TRUE}

docker build bullseye/backports/ --tag ghcr.io/golden-containers/debian:bullseye-backports --label ${1:-DEBUG=TRUE}

# Push

docker push ghcr.io/golden-containers/debian -a
