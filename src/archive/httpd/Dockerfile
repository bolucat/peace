FROM --platform=${TARGETPLATFORM} debian:buster-slim

WORKDIR /root
ARG TARGETPLATFORM
COPY httpd.sh /root/httpd.sh

RUN set -ex \
	&& apt update \
	&& apt install -y wget git sudo binutils \
	&& (yes | apt upgrade) \
	&& chmod +x /root/httpd.sh \
	&& /root/httpd.sh -i \
	&& rm -rfv /root/httpd.sh \
	&& apt-get purge -y wget git binutils \
	&& apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*
	
CMD [ "/usr/local/apache/bin/httpd", "-DFOREGROUND" ]