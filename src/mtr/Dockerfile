FROM --platform=${TARGETPLATFORM} alpine:latest

WORKDIR /root
ARG TARGETPLATFORM

RUN set -ex \
	&& apk add --no-cache git tzdata \
    automake autoconf pkgconfig libtool build-base \
	&& git clone https://github.com/traviscross/mtr \
    && cd ./mtr \
    && chmod +x bootstrap.sh \
    && ./bootstrap.sh \
    && ./configure \
    && make \
    && make install \
    && cd /root \
    && rm -rf mtr \
    && apk del git automake autoconf pkgconfig libtool build-base

ARG OPTIONS
CMD mtr ${OPTIONS}