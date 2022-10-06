FROM --platform=${TARGETPLATFORM} alpine:latest AS builder

WORKDIR /root

RUN set -ex \
	&& VERSION="$(wget -qO- https://api.github.com/repos/trojan-gfw/trojan/tags | grep 'name' | cut -d\" -f4 | head -1)" \
	&& apk add --no-cache git build-base make cmake boost-dev openssl-dev mariadb-connector-c-dev \
	&& git clone https://github.com/trojan-gfw/trojan.git \
	&& cd trojan \
	&& git checkout ${VERSION} \
	&& cmake . \
	&& make \
	&& strip -s trojan

FROM --platform=${TARGETPLATFORM} alpine:latest

COPY --from=builder /root/trojan/trojan /usr/bin
COPY config.json /etc/trojan/config.json

RUN set -ex \
	&& apk add --no-cache tzdata ca-certificates libstdc++ boost-system boost-program_options mariadb-connector-c

VOLUME /etc/trojan
CMD [ "/usr/bin/trojan", "-c", "/etc/trojan/config.json" ]