FROM --platform=${TARGETPLATFORM} alpine:latest

ARG TARGETPLATFORM
COPY tuic.sh /root/tuic.sh
COPY config.json /etc/tuic/config.json

RUN set -ex \
	&& apk add --no-cache libgcc tzdata ca-certificates \
	&& chmod +x /root/tuic.sh \
	&& /root/tuic.sh "${TARGETPLATFORM}" \
	&& rm -fv /root/tuic.sh

VOLUME /etc/tuic
CMD [ "/usr/bin/tuic", "-c", "/etc/tuic/config.json" ]