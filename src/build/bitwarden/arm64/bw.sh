#!/bin/bash

CUR=${PWD}
BITWARDEN=$(wget -qO- https://api.github.com/repos/dani-garcia/vaultwarden/tags | grep 'name' | cut -d\" -f4 | head -1)

DB="sqlite,mysql,postgresql"

sed 's/^deb/deb-src/' /etc/apt/sources.list > /etc/apt/sources.list.d/deb-src.list
dpkg --add-architecture arm64
apt-get update && apt-get install -y --no-install-recommends libssl-dev:arm64 libc6-dev:arm64 libpq5:arm64 libpq-dev libmariadb-dev:arm64 libmariadb-dev-compat:arm64
apt-get update && apt-get install -y --no-install-recommends gcc-aarch64-linux-gnu
mkdir -p ~/.cargo
echo '[target.aarch64-unknown-linux-gnu]' >> ~/.cargo/config
echo 'linker = "aarch64-linux-gnu-gcc"' >> ~/.cargo/config
echo 'rustflags = ["-L/usr/lib/aarch64-linux-gnu"]' >> ~/.cargo/config
export CARGO_HOME="/root/.cargo"
export USER="root"
apt-get install -y --no-install-recommends libmariadb3:amd64
apt-get download libmariadb-dev-compat:amd64
dpkg --force-all -i ./libmariadb-dev-compat*.deb
rm -rvf ./libmariadb-dev-compat*.deb
ln -sfnr /usr/lib/aarch64-linux-gnu/libpq.so.5 /usr/lib/aarch64-linux-gnu/libpq.so
export CC_aarch64_unknown_linux_gnu="/usr/bin/aarch64-linux-gnu-gcc"
export CROSS_COMPILE="1"
export OPENSSL_INCLUDE_DIR="/usr/include/aarch64-linux-gnu"
export OPENSSL_LIB_DIR="/usr/lib/aarch64-linux-gnu"
git clone https://github.com/dani-garcia/vaultwarden bitwarden
pushd bitwarden || exit 1
git checkout ${BITWARDEN}
rustup component list --installed && rustup show
rustup target add aarch64-unknown-linux-gnu
cargo build --features ${DB} --release --target=aarch64-unknown-linux-gnu
find . -not -path "./target*" -delete
popd || exit 1
cp -r bitwarden/target/aarch64-unknown-linux-gnu/release/vaultwarden ./vaultwarden && rm -rf bitwarden