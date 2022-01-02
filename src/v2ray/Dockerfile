FROM --platform=${TARGETPLATFORM} alpine:latest

WORKDIR /root
ARG TARGETPLATFORM
COPY v2ray.sh /root/v2ray.sh
COPY config.json /etc/v2ray/config.json

RUN set -ex \
	&& apk add --no-cache tzdata ca-certificates \
	&& mkdir -p /var/log/v2ray /usr/local/share/v2ray \
	&& chmod +x /root/v2ray.sh \
	&& /root/v2ray.sh "${TARGETPLATFORM}" \
	&& rm -rfv /root/v2ray.sh

VOLUME /etc/v2ray
CMD [ "/usr/bin/v2ray", "run", "-config", "/etc/v2ray/config.json" ]