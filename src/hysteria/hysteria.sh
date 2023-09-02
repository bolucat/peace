#!/bin/sh

PLATFORM=$1
if [ -z "$PLATFORM" ]; then
    ARCH="amd64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="386"
            ;;
        linux/amd64)
            ARCH="amd64"
            ;;
        linux/arm/v6)
            ARCH="arm32-v6"
            ;;
        linux/arm/v7)
            ARCH="arm32-v7"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64"
            ;;
        linux/ppc64le)
            ARCH="ppc64le"
            ;;
        linux/s390x)
            ARCH="s390x"
            ;;
        *)
            ARCH=""
            ;;
    esac
fi
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1

# Download binary file
HYSTERIA_FILE="hysteria-linux-${ARCH}.zip"

echo "Downloading binary file: ${HYSTERIA_FILE}"
VERSION=$(wget -qO- https://raw.githubusercontent.com/bolucat/peace/master/version/hysteria | head -1 | tr -d [:space:])
wget -O $PWD/hysteria.zip https://github.com/bolucat/peace/releases/download/${VERSION}/${HYSTERIA_FILE} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${HYSTERIA_FILE}" && exit 1
fi
echo "Download binary file: ${HYSTERIA_FILE} completed"

echo "Prepare to use"
unzip hysteria.zip && rm -rfv hysteria.zip
chmod +x *-linux-${ARCH}
mv hysteria-linux-${ARCH} /usr/bin/hysteria
mv GeoLite2-Country.mmdb /usr/bin/GeoLite2-Country.mmdb
echo "Done"
