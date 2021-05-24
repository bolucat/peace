FROM --platform=${TARGETPLATFORM} alpine:latest

ARG TARGETPLATFORM
COPY watchtower.sh /root/watchtower.sh

RUN set -ex \
	&& apk add --no-cache tzdata ca-certificates \
	&& chmod +x /root/watchtower.sh \
	&& /root/watchtower.sh "${TARGETPLATFORM}" \
	&& rm -fv /root/watchtower.sh

EXPOSE 8080
ENTRYPOINT ["/watchtower"]