#!/bin/bash

# Set variables
CUR=$PWD
VERSION=$(wget -qO- https://raw.githubusercontent.com/bolucat/peace/master/version/gitea.txt | head -n1 | tr -d [:space:])

# Start Build
mkdir -p ${CUR}/release 
git clone https://github.com/go-gitea/gitea && cd gitea
git branch -a && git checkout ${VERSION}

npx browserslist@latest --update-db

TAG="bindata sqlite sqlite_unlock_notify"

ARCHS=( 386 amd64 arm arm64 ppc64le s390x )
ARMS=( 6 7 )

for ARCH in ${ARCHS[@]}; do
	if [ "${ARCH}" == "arm" ]; then
		for ARM in ${ARMS[@]}; do
			echo "Building gitea-linux-${ARCH}32-v${ARM}"
			GOOS=linux GOARCH=${ARCH} GOARM=${ARM} TAGS=${TAG} make build
			mv gitea ${CUR}/release/gitea-linux-${ARCH}32-v${ARM}
		done
	else
		echo "Building gitea-linux-${ARCH}"
		GOOS=linux GOARCH=${ARCH} TAGS=${TAG} make build
		mv gitea ${CUR}/release/gitea-linux-${ARCH}
	fi
done

# Clean
chmod +x ${CUR}/release/*
cd ${CUR} && rm -rf gitea