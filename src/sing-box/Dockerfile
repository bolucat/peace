FROM --platform=${TARGETPLATFORM} alpine:latest

WORKDIR /root
ARG TARGETPLATFORM
COPY sing-box.sh /root/sing-box.sh
COPY config.json /etc/sing-box/config.json

RUN set -ex \
	&& apk add --no-cache tzdata ca-certificates \
	&& mkdir -p /var/log/sing-box \
	&& chmod +x /root/sing-box.sh \
	&& /root/sing-box.sh "${TARGETPLATFORM}" \
	&& rm -rfv /root/sing-box.sh

VOLUME /etc/sing-box
CMD [ "/usr/bin/sing-box", "run", "--config", "/etc/sing-box/config.json" ]