#!/bin/bash

# Set variables
CUR=$PWD
VERSION=$(wget -qO- https://api.github.com/repos/HyNetwork/hysteria/tags | grep 'name' | cut -d\" -f4 | head -1)

# Get source code
mkdir -p release
git clone https://github.com/HyNetwork/hysteria hysteria
pushd hysteria || exit 1
# git checkout
git checkout ${VERSION}
# get infos
HY_VERSION="$(git describe)"
COMMIT="$(git rev-parse HEAD)"
TIME="$(date "+%F")"
popd || exit 1

# Get GeoLite2-Country.mmdb
wget "https://github.com/Loyalsoldier/geoip/blob/release/GeoLite2-Country.tar.gz?raw=true" -O GeoLite2-Country.tar.gz
mkdir -p GeoLite2-Country
tar -zxf GeoLite2-Country.tar.gz -C GeoLite2-Country/ --strip-components=1
mv GeoLite2-Country/GeoLite2-Country.mmdb release/GeoLite2-Country.mmdb
rm -rfv GeoLite2-Country GeoLite2-Country.tar.gz

# Start Build
LDFLAGS="-s -w -X 'main.appVersion=${HY_VERSION}' -X 'main.appCommit=${COMMIT}' -X 'main.appDate=${TIME}' -buildid="
ARCHS=( 386 amd64 arm arm64 ppc64le s390x )
ARMS=( 6 7 )

for ARCH in ${ARCHS[@]}; do
    if [ "${ARCH}" == "arm" ]; then
        for ARM in ${ARMS[@]}; do
            echo "Building hysteria-linux-${ARCH}32-v${ARM}" && cd ${CUR}/hysteria
            env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} GOARM=${ARM} go build -o ${CUR}/release/hysteria-linux-${ARCH}32-v${ARM} -trimpath -ldflags "${LDFLAGS}" ./app/cmd
            cd ${CUR}/release && zip -9 -r hysteria-linux-${ARCH}32-v${ARM}.zip hysteria-linux-${ARCH}32-v${ARM} GeoLite2-Country.mmdb && rm -rf hysteria-linux-${ARCH}32-v${ARM}
        done
    else
        echo "Building hysteria-linux-${ARCH}" && cd ${CUR}/hysteria
        env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} go build -o ${CUR}/release/hysteria-linux-${ARCH} -trimpath -ldflags "${LDFLAGS}" ./app/cmd
        cd ${CUR}/release && zip -9 -r hysteria-linux-${ARCH}.zip hysteria-linux-${ARCH} GeoLite2-Country.mmdb && rm -rf hysteria-linux-${ARCH}
    fi
done

rm -rfv ${CUR}/release/GeoLite2-Country.mmdb
