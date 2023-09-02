FROM --platform=${TARGETPLATFORM} alpine:latest

WORKDIR /root
ARG TARGETPLATFORM
COPY hysteria.sh /root/hysteria.sh
COPY config.yaml /etc/hysteria/config.yaml

RUN set -ex \
	&& apk add --no-cache tzdata ca-certificates \
	&& mkdir -p /var/www/html /var/log/hysteria /usr/local/share/hysteria \
	&& chmod +x /root/hysteria.sh \
	&& /root/hysteria.sh "${TARGETPLATFORM}" \
	&& rm -rfv /root/hysteria.sh

VOLUME /etc/hysteria
CMD [ "/usr/bin/hysteria", "server", "-c", "/etc/hysteria/config.yaml" ]