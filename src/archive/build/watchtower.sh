# Set variables
CUR=$PWD
version=$(wget -qO- https://api.github.com/repos/containrrr/watchtower/tags | grep 'name' | cut -d\" -f4 | head -1)

# Get source code
mkdir -p release
git clone https://github.com/containrrr/watchtower.git && cd watchtower
git checkout ${version}

# Start Build
ARCHS=( 386 amd64 arm arm64 ppc64le s390x )
ARMS=( 6 7 )

for ARCH in ${ARCHS[@]}; do
    if [ "${ARCH}" == "arm" ]; then
        for ARM in ${ARMS[@]}; do
            echo "Building watchtower-linux-${ARCH}32-v${ARM}" && cd ${CUR}/watchtower
            env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} GOARM=${ARM} go build -o ${CUR}/release/watchtower-linux-${ARCH}32-v${ARM} -trimpath -ldflags "-X github.com/containrrr/watchtower/cmd.version=$VERSION"
        done
    else
        echo "Building watchtower-linux-${ARCH}" && cd ${CUR}/watchtower
        env CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} go build -o ${CUR}/release/watchtower-linux-${ARCH} -trimpath -ldflags "-X github.com/containrrr/watchtower/cmd.version=$VERSION"
    fi
done