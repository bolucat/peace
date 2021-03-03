FROM --platform=${TARGETPLATFORM} debian:buster-slim

ENV ROCKET_ENV "staging"
ENV ROCKET_PORT=80
ENV ROCKET_WORKERS=10

ARG TARGETPLATFORM
COPY bitwarden.sh /bitwarden.sh

RUN set -ex \
	&& mkdir /data \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
    openssl ca-certificates curl wget dumb-init \
    sqlite3 libmariadb-dev-compat libpq5 \
	&& (yes | apt-get upgrade) \
    && rm -rf /var/lib/apt/lists/* \
	&& chmod +x /bitwarden.sh \
	&& /bitwarden.sh "${TARGETPLATFORM}" \
	&& rm -rfv /bitwarden.sh

VOLUME /data
EXPOSE 80
EXPOSE 3012

COPY Rocket.toml .
COPY start.sh /start.sh
COPY healthcheck.sh /healthcheck.sh

HEALTHCHECK --interval=60s --timeout=10s CMD ["/healthcheck.sh"]

WORKDIR /
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/start.sh"]