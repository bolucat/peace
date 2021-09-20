#!/bin/bash

PLATFORM=$1
if [ -z "$PLATFORM" ]; then
    ARCH="amd64"
else
    case "$PLATFORM" in
        linux/amd64)
            ARCH="amd64"
            ;;
        linux/arm/v6)
            ARCH="armv6"
            ;;
        linux/arm/v7)
            ARCH="armv7"
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

BITWARDEN_FILE="bitwarden-${ARCH}.tar.gz"

echo "Downloading binary file: ${BITWARDEN_FILE}"
wget -O bitwarden.tar.gz https://github.com/bolucat/peace/releases/latest/download/${BITWARDEN_FILE} > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${BITWARDEN_FILE}" && exit 1
fi
echo "Download binary file: ${BITWARDEN_FILE} completed"

# Prepare
tar -zxvf bitwarden.tar.gz && rm -rfv bitwarden.tar.gz
mv bitwarden-${ARCH} ./vaultwarden && tar -zxf web-vault.tar.gz
rm -rfv web-vault.tar.gz && chmod +x ./vaultwarden
echo "Done"