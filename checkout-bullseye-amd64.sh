#!/bin/sh

set -xe

rm -rf docker-debian-artifacts
git clone --depth 1 --branch dist-amd64 --filter=blob:none --sparse https://github.com/debuerreotype/docker-debian-artifacts
cd docker-debian-artifacts
git sparse-checkout init --cone
git sparse-checkout set bullseye

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/bullseye/; t" -e "1,// s//ghcr.io\/golden-containers\/bullseye/" bullseye/backports/Dockerfile
