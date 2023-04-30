FROM --platform=${TARGETPLATFORM} node:18-alpine

WORKDIR /root
ARG TARGETPLATFORM

RUN set -ex \
    && apk add --no-cache git wget tzdata \
    make nasm autoconf automake libtool dpkg \
    pkgconfig libpng libpng-dev g++ \
    && git clone https://github.com/mdn/content \
    && mv content/* /root \
    && rm -rf content \
    && npm install -g npm@latest \
    && npm --force install -g yarn \
    && yarn config set network-timeout 600000 -g \
    && yarn \
    && echo "SERVER_PORT=5000" >> .env \
    && apk del git wget make automake autoconf

EXPOSE 5000
VOLUME /root
CMD [ "yarn", "start" ]
