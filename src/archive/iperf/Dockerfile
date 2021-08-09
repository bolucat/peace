FROM --platform=${TARGETPLATFORM} alpine:edge

WORKDIR /root
ARG TARGETPLATFORM

RUN set -ex \
	&& apk add --no-cache git tzdata \
    automake autoconf pkgconfig libtool build-base \
	&& git clone https://github.com/esnet/iperf \
    && cd ./iperf \
    && chmod +x bootstrap.sh \
    && ./bootstrap.sh \
    && ./configure \
    && make \
    && make install \
    && cd /root \
    && rm -rf iperf \
    && apk del git automake autoconf pkgconfig libtool build-base

ARG OPTIONS
CMD iperf3 ${OPTIONS}