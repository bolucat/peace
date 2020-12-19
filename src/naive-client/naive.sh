#!/bin/sh

# Set ARG
PLATFORM=$1
if [ -z "$PLATFORM" ]; then
    ARCH="x64"
else
    case "$PLATFORM" in
        linux/amd64)
            ARCH="x64"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64"
            ;;
        *)
            ARCH=""
            ;;
    esac
fi
[ -z "${ARCH}" ] && echo "Error: Not support" && exit 1

# Download files
VERSION=$(wget -qO- https://api.github.com/repos/klzgrad/naiveproxy/tags | grep 'name' | cut -d\" -f4 | head -n1)
FILE="naiveproxy-${VERSION}-linux-${ARCH}.tar.xz"
FOLDER="naiveproxy-${VERSION}-linux-${ARCH}"

wget https://github.com/klzgrad/naiveproxy/releases/download/${VERSION}/${FILE}
tar -xvJf ${FILE} && rm -fv ${FILE}

# Prepare
chmod +x ${FOLDER}/naive && mv ${FOLDER}/naive /usr/bin/naive && strip -s /usr/bin/naive
mv ${FOLDER}/config.json /etc/naiveproxy/config.json