#!/bin/sh

# Set ARG
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
[ -z "${ARCH}" ] && echo "Error: Not support" && exit 1

# Download files
NAIVE_FILE="naive-linux-${ARCH}"

echo "Downloading binary file: ${NAIVE_FILE}"
wget -O /usr/bin/naive https://github.com/bolucat/peace/releases/latest/download/${NAIVE_FILE} > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${NAIVE_FILE}" && exit 1
fi
echo "Download binary file: ${NAIVE_FILE} completed"

# Prepare
chmod +x /usr/bin/naive && strip -s /usr/bin/naive