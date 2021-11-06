#!/bin/sh

set -e

rm -rf docker-debian-artifacts
git clone --depth 1 --branch dist-amd64 --filter=blob:none --sparse https://github.com/jgowdy/docker-debian-artifacts.git
cd docker-debian-artifacts
git sparse-checkout init --cone
git sparse-checkout set bullseye

sed -i -e "1 s/FROM.*/FROM ghcr.io\/jgowdy\/bullseye/; t" -e "1,// s//ghcr.io\/jgowdy\/bullseye/" bullseye/backports/Dockerfile

pwd
find .
