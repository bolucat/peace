#!/bin/bash

CUR=${PWD}
BITWARDEN=$(wget -qO- https://api.github.com/repos/dani-garcia/vaultwarden/tags | grep 'name' | cut -d\" -f4 | head -1)

DB="sqlite,mysql,postgresql"

apt-get update && apt-get install -y --no-install-recommends libmariadb-dev libpq-dev
git clone https://github.com/dani-garcia/vaultwarden bitwarden
pushd bitwarden || exit 1
git checkout ${BITWARDEN}
cargo build --features ${DB} --release
find . -not -path "./target*" -delete
popd || exit 1
cp -r bitwarden/target/release/vaultwarden ./vaultwarden && rm -rf bitwarden