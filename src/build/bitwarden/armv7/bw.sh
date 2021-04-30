#!/bin/bash

CUR=${PWD}
BITWARDEN=$(wget -qO- https://api.github.com/repos/dani-garcia/vaultwarden/tags | grep 'name' | cut -d\" -f4 | head -1)

DB="sqlite,mysql,postgresql"

sed 's/^deb/deb-src/' /etc/apt/sources.list > /etc/apt/sources.list.d/deb-src.list
dpkg --add-architecture armhf
apt-get update && apt-get install -y --no-install-recommends libssl-dev:armhf libc6-dev:armhf libpq5:armhf libpq-dev libmariadb-dev:armhf libmariadb-dev-compat:armhf
apt-get update && apt-get install -y --no-install-recommends gcc-arm-linux-gnueabihf
mkdir -p ~/.cargo
echo '[target.armv7-unknown-linux-gnueabihf]' >> ~/.cargo/config
echo 'linker = "arm-linux-gnueabihf-gcc"' >> ~/.cargo/config
echo 'rustflags = ["-L/usr/lib/arm-linux-gnueabihf"]' >> ~/.cargo/config
export CARGO_HOME="/root/.cargo"
apt-get install -y --no-install-recommends libmariadb3:amd64
apt-get download libmariadb-dev-compat:amd64
dpkg --force-all -i ./libmariadb-dev-compat*.deb
rm -rvf ./libmariadb-dev-compat*.deb
ln -sfnr /usr/lib/arm-linux-gnueabihf/libpq.so.5 /usr/lib/arm-linux-gnueabihf/libpq.so
export CC_armv7_unknown_linux_gnueabihf="/usr/bin/arm-linux-gnueabihf-gcc"
export CROSS_COMPILE="1"
export OPENSSL_INCLUDE_DIR="/usr/include/arm-linux-gnueabihf"
export OPENSSL_LIB_DIR="/usr/lib/arm-linux-gnueabihf"
git clone https://github.com/dani-garcia/vaultwarden bitwarden
pushd bitwarden || exit 1
git checkout ${BITWARDEN}
rustup component list --installed && rustup show
rustup target add armv7-unknown-linux-gnueabihf
cargo build --features ${DB} --release --target=armv7-unknown-linux-gnueabihf
find . -not -path "./target*" -delete
popd || exit 1
cp -r bitwarden/target/armv7-unknown-linux-gnueabihf/release/vaultwarden ./vaultwarden && rm -rf bitwarden