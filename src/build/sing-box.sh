#!/bin/bash

# Set variables
CUR=$PWD
VERSION=$(wget -qO- https://raw.githubusercontent.com/bolucat/peace/master/version/sing-box.txt | head -n1 | tr -d [:space:])

# Get source code
mkdir -p release
wget -O release/geosite.db https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db
wget -O release/geoip.db https://github.com/SagerNet/sing-geoip/releases/latest/download/geoip.db

git clone -b dev-next https://github.com/SagerNet/sing-box sing-box
pushd sing-box || exit 1
git checkout ${VERSION}
export COMMIT=$(git rev-parse --short HEAD)
export VERSION=$(go run ./cmd/internal/read_tag)
popd || exit 1

# Start Build
ARCHS=( 386 amd64 arm arm64 ppc64le s390x )
ARMS=( 6 7 )

for ARCH in ${ARCHS[@]}; do
	if [ "${ARCH}" == "arm" ]; then
		for ARM in ${ARMS[@]}; do
			echo "Building sing-box-linux-${ARCH}32-v${ARM}" && cd ${CUR}/sing-box
			env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} GOARM=${ARM} go build -o ${CUR}/release/sing-box-linux-${ARCH}32-v${ARM} -trimpath -tags 'with_quic,with_grpc,with_dhcp,with_wireguard,with_ech,with_utls,with_reality_server,with_acme,with_clash_api,with_v2ray_api,with_gvisor' -ldflags "-X github.com/sagernet/sing-box/constant.Version=${VERSION} -w -s -buildid=" ./cmd/sing-box
			cd ${CUR}/release && zip -9 -r sing-box-linux-${ARCH}32-v${ARM}.zip *-linux-${ARCH}32-v${ARM} geoip.db geosite.db && rm -rf *-linux-${ARCH}32-v${ARM}
		done
	else
		echo "Building sing-box-linux-${ARCH}" && cd ${CUR}/sing-box
		env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} go build -o ${CUR}/release/sing-box-linux-${ARCH} -trimpath -tags 'with_quic,with_grpc,with_dhcp,with_wireguard,with_ech,with_utls,with_reality_server,with_acme,with_clash_api,with_v2ray_api,with_gvisor' -ldflags "-X github.com/sagernet/sing-box/constant.Version=${VERSION} -w -s -buildid=" ./cmd/sing-box
		cd ${CUR}/release && zip -9 -r sing-box-linux-${ARCH}.zip *-linux-${ARCH} geoip.db geosite.db && rm -rf *-linux-${ARCH}
	fi
done

# Build Windows-amd64
echo "Building sing-box-windows-amd64" && cd ${CUR}/sing-box
env CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o ${CUR}/release/sing-box.exe -trimpath -tags 'with_quic,with_grpc,with_dhcp,with_wireguard,with_ech,with_utls,with_reality_server,with_acme,with_clash_api,with_v2ray_api,with_gvisor' -ldflags "-X github.com/sagernet/sing-box/constant.Version=${VERSION} -w -s -buildid=" ./cmd/sing-box
cd ${CUR}/release && zip -9 -r sing-box-windows-amd64.zip *.exe geoip.db geosite.db && rm -rf *.exe

rm -rf ${CUR}/release/{"geoip.db","geosite.db"}
