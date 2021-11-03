#!/bin/sh

set -e

rm -rf docker-debian-artifacts
git clone --depth 1 --branch dist-amd64 --filter=blob:none --sparse git@github.com:jgowdy/docker-debian-artifacts.git
cd docker-debian-artifacts
git sparse-checkout init --cone
git sparse-checkout set bullseye

#cd bullseye
#docker build . -t jgowdy-bullseye:latest
#cd slim
#docker build . -t jgowdy-slim-bullseye:latest

