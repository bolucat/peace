#!/bin/bash

CUR=${PWD}
BITWARDEN=$(wget -qO- https://api.github.com/repos/dani-garcia/vaultwarden/tags | grep 'name' | cut -d\" -f4 | head -1)

DB="sqlite,mysql,postgresql"

sed 's/^deb/deb-src/' /etc/apt/sources.list > /etc/apt/sources.list.d/deb-src.list
dpkg --add-architecture armel
apt-get update && apt-get install -y --no-install-recommends libssl-dev:armel libc6-dev:armel libpq5:armel libpq-dev libmariadb-dev:armel libmariadb-dev-compat:armel
apt-get update && apt-get install -y --no-install-recommends gcc-arm-linux-gnueabi
mkdir -p ~/.cargo
echo '[target.arm-unknown-linux-gnueabi]' >> ~/.cargo/config
echo 'linker = "arm-linux-gnueabi-gcc"' >> ~/.cargo/config
echo 'rustflags = ["-L/usr/lib/arm-linux-gnueabi"]' >> ~/.cargo/config
export CARGO_HOME="/root/.cargo"
apt-get install -y --no-install-recommends libmariadb3:amd64
apt-get download libmariadb-dev-compat:amd64
dpkg --force-all -i ./libmariadb-dev-compat*.deb
rm -rvf ./libmariadb-dev-compat*.deb
ln -sfnr /usr/lib/arm-linux-gnueabi/libpq.so.5 /usr/lib/arm-linux-gnueabi/libpq.so
export CC_arm_unknown_linux_gnueabi="/usr/bin/arm-linux-gnueabi-gcc"
export CROSS_COMPILE="1"
export OPENSSL_INCLUDE_DIR="/usr/include/arm-linux-gnueabi"
export OPENSSL_LIB_DIR="/usr/lib/arm-linux-gnueabi"
git clone https://github.com/dani-garcia/vaultwarden bitwarden
pushd bitwarden || exit 1
git checkout ${BITWARDEN}
rustup component list --installed && rustup show
rustup target add arm-unknown-linux-gnueabi
cargo build --features ${DB} --release --target=arm-unknown-linux-gnueabi
find . -not -path "./target*" -delete
popd || exit 1
cp -r bitwarden/target/arm-unknown-linux-gnueabi/release/vaultwarden ./vaultwarden && rm -rf bitwarden