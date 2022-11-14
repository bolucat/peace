#!/bin/bash

# Set variables
CUR=$PWD
VERSION=$(wget -qO- https://api.github.com/repos/XTLS/Xray-core/tags | grep 'name' | cut -d\" -f4 | head -1)

# Get source code
mkdir -p release
wget -O release/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
wget -O release/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat

git clone https://github.com/XTLS/Xray-core Xray-core
cd Xray-core && git checkout ${VERSION}

# Start Build
ARCHS=( 386 amd64 arm arm64 ppc64le s390x )
ARMS=( 6 7 )

for ARCH in ${ARCHS[@]}; do
	if [ "${ARCH}" == "arm" ]; then
		for ARM in ${ARMS[@]}; do
			echo "Building xray-linux-${ARCH}32-v${ARM}" && cd ${CUR}/Xray-core
			env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} GOARM=${ARM} go build -o ${CUR}/release/xray-linux-${ARCH}32-v${ARM} -trimpath -ldflags "-s -w -buildid=" ./main
			cd ${CUR}/release && zip xray-linux-${ARCH}32-v${ARM}.zip xray-linux-${ARCH}32-v${ARM} geoip.dat geosite.dat && rm -rf xray-linux-${ARCH}32-v${ARM}
		done
	else
		echo "Building xray-linux-${ARCH}" && cd ${CUR}/Xray-core
		env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} go build -o ${CUR}/release/xray-linux-${ARCH} -trimpath -ldflags "-s -w -buildid=" ./main
		cd ${CUR}/release && zip xray-linux-${ARCH}.zip xray-linux-${ARCH} geoip.dat geosite.dat && rm -rf xray-linux-${ARCH}
	fi
done

# Build Windows-amd64
rm -rf ${CUR}/release/{"geoip.dat","geosite.dat"}
# Change to Loyalsoldier source when compile Windows packages
wget -O ${CUR}/release/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
wget -O ${CUR}/release/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
echo "Building xray-windows-amd64" && cd ${CUR}/Xray-core
env CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o ${CUR}/release/xray.exe -trimpath -ldflags "-s -w -buildid=" ./main
cd ${CUR}/release && zip -9 -r xray-windows-amd64.zip *.exe geoip.dat geosite.dat && rm -rf *.exe

rm -rf ${CUR}/release/{"geoip.dat","geosite.dat"}