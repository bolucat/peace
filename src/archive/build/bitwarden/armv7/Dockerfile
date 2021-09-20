FROM rust:latest

WORKDIR /root
COPY bw.sh /root/bw.sh

ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 TZ=UTC TERM=xterm-256color

RUN set -ex \
	&& (apt-get update && apt-get install -y wget git) \ 
	&& (yes | apt-get upgrade) \
	&& rustup set profile minimal \
	&& chmod +x /root/bw.sh \
	&& bash /root/bw.sh \
	&& rm -rfv /root/bw.sh

CMD ["top"]