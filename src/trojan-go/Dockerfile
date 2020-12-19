FROM --platform=${TARGETPLATFORM} alpine:latest

ARG TARGETPLATFORM
COPY trojan-go.sh /root/trojan-go.sh
COPY config.json /etc/trojan-go/config.json

RUN set -ex \
	&& apk add --no-cache tzdata ca-certificates \
	&& chmod +x /root/trojan-go.sh \
	&& /root/trojan-go.sh "${TARGETPLATFORM}" \
	&& rm -fv /root/trojan-go.sh

VOLUME /etc/trojan-go
CMD [ "/usr/bin/trojan-go", "-config", "/etc/trojan-go/config.json" ]