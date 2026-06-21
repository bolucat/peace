FROM --platform=${TARGETPLATFORM} node:24-alpine

WORKDIR /root
ARG TARGETPLATFORM

RUN corepack enable
RUN corepack prepare yarn@stable --activate

RUN set -ex \
    && apk add --no-cache git wget tzdata \
    make nasm autoconf automake libtool dpkg \
    pkgconfig libpng libpng-dev g++ \
    && git clone https://github.com/mdn/content \
    && mv content/* /root \
    && mv content/.git /root \
    && rm -rf content \
    && npm install \
    && echo "SERVER_PORT=5000" >> .env \
    && apk del git wget make automake autoconf

EXPOSE 5000
VOLUME /root
CMD [ "npm", "start" ]
