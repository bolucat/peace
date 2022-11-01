#!/bin/bash

# Set variables
CUR=$PWD
RELEASE_VER=$(wget -qO- https://api.github.com/repos/p4gefau1t/trojan-go/tags | grep 'name' | cut -d\" -f4 | head -1)

# Get source code
mkdir -p release
wget -O release/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
wget -O release/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat

git clone https://github.com/p4gefau1t/trojan-go trojan-go
cd trojan-go && git checkout ${RELEASE_VER}

PACKAGE_NAME="github.com/p4gefau1t/trojan-go"
VERSION="$(git describe)"
COMMIT="$(git rev-parse HEAD)"

VAR_SETTING=""
VAR_SETTING="${VAR_SETTING} -X ${PACKAGE_NAME}/constant.Version=${VERSION}"
VAR_SETTING="${VAR_SETTING} -X ${PACKAGE_NAME}/constant.Commit=${COMMIT}"

# Start Build
ARCHS=( 386 amd64 arm arm64 ppc64le s390x )
ARMS=( 6 7 )

for ARCH in ${ARCHS[@]}; do
    if [ "${ARCH}" == "arm" ]; then
        for ARM in ${ARMS[@]}; do
            echo "Building trojan-go-linux-${ARCH}32-v${ARM}" && cd ${CUR}/trojan-go
            env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} GOARM=${ARM} go build -o ${CUR}/release/trojan-go-linux-${ARCH}32-v${ARM} -trimpath -tags "full" -ldflags "-s -w ${VAR_SETTING}"
            cd ${CUR}/release && zip trojan-go-linux-${ARCH}32-v${ARM}.zip trojan-go-linux-${ARCH}32-v${ARM} geoip.dat geosite.dat && rm -rf trojan-go-linux-${ARCH}32-v${ARM}
        done
    else
        echo "Building trojan-go-linux-${ARCH}" && cd ${CUR}/trojan-go
        env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} go build -o ${CUR}/release/trojan-go-linux-${ARCH} -trimpath -tags "full" -ldflags "-s -w ${VAR_SETTING}"
        cd ${CUR}/release && zip trojan-go-linux-${ARCH}.zip trojan-go-linux-${ARCH} geoip.dat geosite.dat && rm -rf trojan-go-linux-${ARCH}
    fi
done

rm -rf ${CUR}/release/{"geoip.dat","geosite.dat"}