FROM --platform=${TARGETPLATFORM} ubuntu:latest

WORKDIR /root
ARG TARGETPLATFORM
COPY naive.sh /root/naive.sh

RUN (apt update && apt install -y wget xz-utils libnss3 binutils && rm -rf /var/lib/apt/lists/*) \
 && (yes | apt upgrade) \
 && mkdir -p /etc/naiveproxy /var/log/naive \
 && chmod +x /root/naive.sh \
 && /root/naive.sh "${TARGETPLATFORM}" \
 && rm -fv /root/naive.sh

VOLUME /etc/naiveproxy
CMD [ "/usr/bin/naive", "/etc/naiveproxy/config.json" ]