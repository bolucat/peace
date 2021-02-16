#!/bin/bash

# Set variables
QUIC=$(wget -qO- https://api.github.com/repos/lucas-clemente/quic-go/tags | grep 'name' | cut -d\" -f4 | head -1)
PROTOCOL=$(wget -qO- https://api.github.com/repos/mastercactapus/caddy2-proxyprotocol/tags | grep 'name' | cut -d\" -f4 | head -1)

# Get source code
go get -u github.com/caddyserver/xcaddy/cmd/xcaddy
git clone -b naive https://github.com/klzgrad/forwardproxy
git clone -b ${QUIC} https://github.com/lucas-clemente/quic-go
git clone -b ${PROTOCOL} https://github.com/mastercactapus/caddy2-proxyprotocol.git

# Start Build
NAIVE="--with github.com/caddyserver/forwardproxy=$PWD/forwardproxy"
QUIC_GO="--with github.com/lucas-clemente/quic-go=$PWD/quic-go"
PROTOCOLS="--with github.com/mastercactapus/caddy2-proxyprotocol=$PWD/caddy2-proxyprotocol"

ARCHS=( 386 amd64 arm arm64 ppc64le s390x )
ARMS=( 6 7 )

mkdir -p release

for ARCH in ${ARCHS[@]}; do
	if [ "${ARCH}" == "arm" ]; then
		for ARM in ${ARMS[@]}; do
			echo "Building caddy-linux-${ARCH}32-v${ARM}"
			env GOOS=linux GOARCH=${ARCH} GOARM=${ARM} $GOPATH/bin/xcaddy build HEAD --output release/caddy-linux-${ARCH}32-v${ARM} ${NAIVE} ${QUIC_GO} ${PROTOCOLS}
		done
	else
		echo "Building caddy-linux-${ARCH}"
		env GOOS=linux GOARCH=${ARCH} $GOPATH/bin/xcaddy build HEAD --output release/caddy-linux-${ARCH} ${NAIVE} ${QUIC_GO} ${PROTOCOLS}
	fi
done