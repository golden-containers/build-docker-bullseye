#!/bin/sh

set -xe
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch dist-amd64 --filter=blob:none --sparse https://github.com/debuerreotype/docker-debian-artifacts
cd docker-debian-artifacts
git sparse-checkout init --cone
git sparse-checkout set bullseye

# Transform

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye/; t" -e "1,// s//ghcr.io\/golden-containers\/bullseye/" bullseye/backports/Dockerfile

# Build

docker build bullseye --tag ghcr.io/golden-containers/bullseye:latest

docker build bullseye/slim --tag ghcr.io/golden-containers/bullseye-slim:latest

docker build bullseye/backports --tag ghcr.io/golden-containers/bullseye-backports:latest

# Push

docker push ghcr.io/golden-containers/bullseye:latest

docker push ghcr.io/golden-containers/bullseye-slim:latest

docker push ghcr.io/golden-containers/bullseye-backports:latest
