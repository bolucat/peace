#!/bin/sh

PLATFORM=$1
if [ -z "$PLATFORM" ]; then
    ARCH="amd64"
else
    case "$PLATFORM" in
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
        *)
            ARCH=""
            ;;
    esac
fi
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1

# Download binary file
SS_FILE="ss-rust-linux-${ARCH}.zip"

echo "Downloading binary file: ${SS_FILE}"
VERSION=$(wget -qO- https://raw.githubusercontent.com/bolucat/peace/master/version/ss-rust | head -1 | tr -d [:space:])
wget -O $PWD/ss-rust.zip https://github.com/bolucat/peace/releases/download/${VERSION}/${SS_FILE} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${SS_FILE}" && exit 1
fi
echo "Download binary file: ${SS_FILE} completed"

echo "Prepare to use"
unzip ss-rust.zip && rm -rfv ss-rust.zip
chmod +x ss* v2ray-*
mv v2ray-plugin-${ARCH} /usr/bin/v2ray-plugin
mv ss* /usr/bin/