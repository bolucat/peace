FROM --platform=${TARGETPLATFORM} node:current-alpine

WORKDIR /root
ARG TARGETPLATFORM

RUN set -ex \
    && apk add --no-cache git wget tzdata \
    make nasm autoconf automake libtool dpkg \
    pkgconfig libpng libpng-dev g++ \
    && git clone https://github.com/VickScarlet/lifeRestart \
    && mv lifeRestart/* /root \
    && rm -rf lifeRestart \
    && npm --force install -g yarn \
    && yarn install \
    && apk del git wget make automake autoconf

EXPOSE 8081
VOLUME /root
CMD [ "yarn", "dev" ]
