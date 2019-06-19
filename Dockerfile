FROM debian:jessie-slim

MAINTAINER DJANTA, LLC <team.docker@djanta.io>

LABEL credit="http://www.clamav.net/download"
LABEL description="Clamav docker distribuate server"
LABEL version="0.0.1"
LABEL maintainer="DJANTA, LLC <team.docker@djanta.io>"

# explicitly set user/group IDs
RUN groupadd -r clamav --gid=999 && useradd -r -g clamav --uid=999 clamav

ARG DEBIAN_FRONTEND

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_VERSION jessie

RUN echo "deb http://http.debian.net/debian/ $DEBIAN_VERSION main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://http.debian.net/debian/ $DEBIAN_VERSION-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ $DEBIAN_VERSION/updates main contrib non-free" >> /etc/apt/sources.list && \

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.10
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget locales \
	qq clamav-daemon clamav-freshclam libclamunrar7 \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

ENV LANG en_US.utf8

# initial update of av databases
RUN wget -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd \
    && wget -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd \
    && wget -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd \
    && chown clamav:clamav /var/lib/clamav/*.cvd

# Clean up apt
RUN apt-get purge -y --auto-remove ca-certificates wget \
    && apt-get clean \
    && rm -rfv /var/lib/apt/lists/*

# permission juggling
RUN mkdir /var/run/clamav \
    && chown clamav:clamav /var/run/clamav \
    && chmod 750 /var/run/clamav

# av configuration update
RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    echo "TCPSocket 3310" >> /etc/clamav/clamd.conf && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

# volume provision
VOLUME ["/var/lib/clamav"]

COPY entrypoint.sh /usr/local/bin/

RUN chmod o+x /usr/local/bin/entrypoint.sh

#Define the default entry point
ENTRYPOINT ["entrypoint.sh"]

# Expose the port
EXPOSE 3310

CMD ["entrypoint.sh", ""]
