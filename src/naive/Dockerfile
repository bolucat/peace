FROM --platform=${TARGETPLATFORM} alpine:latest

WORKDIR /root
ARG TARGETPLATFORM
COPY naive.sh /root/naive.sh
COPY Caddyfile /etc/naiveproxy/Caddyfile
COPY config.json /etc/naiveproxy/config.json

RUN set -ex \
	&& apk add --no-cache tzdata ca-certificates \
	&& mkdir -p /var/www/html /var/log/naiveproxy \
	&& chmod +x /root/naive.sh \
	&& /root/naive.sh "${TARGETPLATFORM}" \
	&& rm -fv /root/naive.sh

ARG PATH
VOLUME /etc/naiveproxy
CMD /usr/bin/caddy run --config ${PATH}