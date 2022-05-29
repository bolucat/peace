FROM --platform=${TARGETPLATFORM} alpine:latest

ARG TARGETPLATFORM
COPY ss-rust.sh /root/ss-rust.sh
COPY config.json /etc/ss-rust/config.json

RUN set -ex \
	&& apk add --no-cache libgcc tzdata ca-certificates \
	&& chmod +x /root/ss-rust.sh \
	&& /root/ss-rust.sh "${TARGETPLATFORM}" \
	&& rm -fv /root/ss-rust.sh

VOLUME /etc/ss-rust
CMD [ "/usr/bin/ssserver", "--log-without-time", "-c", "/etc/ss-rust/config.json" ]