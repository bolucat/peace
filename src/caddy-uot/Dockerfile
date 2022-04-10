FROM --platform=${TARGETPLATFORM} alpine:latest

WORKDIR /root
ARG TARGETPLATFORM
COPY caddy.sh /root/caddy.sh
COPY Caddyfile /etc/naiveproxy/Caddyfile
COPY config.json /etc/naiveproxy/config.json

RUN set -ex \
	&& apk add --no-cache tzdata ca-certificates \
	&& mkdir -p /var/www/html /var/log/naiveproxy \
	&& chmod +x /root/caddy.sh \
	&& /root/caddy.sh "${TARGETPLATFORM}" \
	&& rm -fv /root/caddy.sh

ARG PATH
VOLUME /etc/naiveproxy
CMD /usr/bin/caddy run --config ${PATH}