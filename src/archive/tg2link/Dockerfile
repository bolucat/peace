FROM --platform=${TARGETPLATFORM} python:alpine

WORKDIR /root
ARG TARGETPLATFORM

RUN set -ex \
	&& apk add --no-cache git gcc musl-dev tzdata \
	&& git clone https://github.com/EverythingSuckz/TG-FileStreamBot StreamBot \
	&& mv StreamBot/* /root \
	&& rm -rf StreamBot \
	&& touch .env \
	&& pip3 install --upgrade pip \
	&& pip3 install -r requirements.txt

CMD python3 -m WebStreamer