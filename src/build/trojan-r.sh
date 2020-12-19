#!/bin/bash

# get packages
CUR=${PWD}
ARCHS=( "i686-unknown-linux-musl" "x86_64-unknown-linux-musl" "arm-unknown-linux-musleabihf" "armv7-unknown-linux-musleabihf" "aarch64-unknown-linux-musl" "aarch64-linux-android" "armv7-linux-androideabi" "i686-linux-android" "x86_64-linux-android" )
RELEASE=( "linux-386" "linux-amd64" "linux-arm32-v6" "linux-arm32-v7" "linux-arm64" "android-arm64" "android-arm32-v7" "android-386" "android-amd64" )

cargo install cross

for ARCH in ${ARCHS[@]}; do
	rustup target add ${ARCH}
done

# get source code
git clone https://github.com/p4gefau1t/trojan-r.git && cd trojan-r

# start build
for ARCH in ${ARCHS[@]}; do
	echo "Starting build ${ARCH}"
	cross build --target ${ARCH} --release
done

# prepare to release
cd ${CUR} && mkdir -p release

for (( i = 0; i <= 9; i++ )); do
	echo "Copying trojan-r-${RELEASE[i]}"
	cp trojan-r/target/${ARCHS[i]}/release/trojan-r release/trojan-r-${RELEASE[i]}
	echo "Creating HASH files"
done

strip -s release/trojan-r-linux-386 && strip -s release/trojan-r-linux-amd64