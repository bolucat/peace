FROM --platform=${TARGETPLATFORM} debian:bullseye-slim

WORKDIR /root
ARG TARGETPLATFORM
COPY naive.sh /root/naive.sh
COPY config.json /etc/naiveproxy/config.json

RUN set -ex \
    && apt-get update \ 
    && apt-get install -y wget binutils \
    && mkdir -p /etc/naiveproxy /var/log/naive \
    && chmod +x /root/naive.sh \
    && /root/naive.sh "${TARGETPLATFORM}" \
    && rm -fv /root/naive.sh \
    && apt-get purge -y wget binutils \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

VOLUME /etc/naiveproxy
CMD [ "/usr/bin/naive", "/etc/naiveproxy/config.json" ]
