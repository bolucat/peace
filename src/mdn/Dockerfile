FROM --platform=${TARGETPLATFORM} node:slim

WORKDIR /root
ARG TARGETPLATFORM

RUN set -ex \
    && apt-get update \ 
    && apt-get install -y git wget autoconf dh-autoreconf \
    && git clone https://github.com/mdn/content \
    && mv content/* /root \
    && rm -rf content \
    && npm --force install -g yarn \
    && yarn \
    && apt-get purge -y git wget \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 5000
VOLUME /root
CMD [ "yarn", "start" ]