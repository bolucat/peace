#!/bin/bash

# Set variables
CUR=$PWD
VERSION=$(wget -qO- https://api.github.com/repos/go-gitea/gitea/releases/latest | grep 'tag_name' | cut -d\" -f4 | head -1)

# Start Build
git clone https://github.com/go-gitea/gitea && cd gitea
git branch -a && git checkout ${VERSION}

npx browserslist@latest --update-db
TAGS="bindata sqlite sqlite_unlock_notify" make build
mkdir -p ${CUR}/release && mv gitea ${CUR}/release/gitea_amd64

CC=aarch64-unknown-linux-gnu-gcc GOOS=linux GOARCH=arm64 TAGS="bindata sqlite sqlite_unlock_notify" make build
mv gitea ${CUR}/release/gitea_arm64 && chmod +x ${CUR}/release/*

# Clean
cd ${CUR} && rm -rf gitea