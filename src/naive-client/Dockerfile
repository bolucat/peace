FROM --platform=${TARGETPLATFORM} debian:buster-slim

WORKDIR /root
ARG TARGETPLATFORM
COPY naive.sh /root/naive.sh
COPY config.json /etc/naiveproxy/config.json

RUN (apt update && apt install -y wget libnss3 binutils) \
 && (yes | apt upgrade) \
 && mkdir -p /etc/naiveproxy /var/log/naive \
 && chmod +x /root/naive.sh \
 && /root/naive.sh "${TARGETPLATFORM}" \
 && rm -fv /root/naive.sh

VOLUME /etc/naiveproxy
CMD [ "/usr/bin/naive", "/etc/naiveproxy/config.json" ]