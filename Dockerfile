# Errbot - the pluggable chatbot

FROM alpine:3.6

MAINTAINER Ali S Ardestani <ali.sade@gmail.com>

ENV ERR_USER err
ENV PATH /app/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Add err user and group
RUN addgroup -S $ERR_USER && adduser -S -g $ERR_USER $ERR_USER -h /srv

# Install packages and perform cleanup
RUN apk add --update \
    bash \
    libxslt-dev \
    libxml2-dev \
    openssl-dev \
    libffi-dev \
    ca-certificates \
    python3 \
    python3-dev \
    build-base \
  && pip3 install virtualenv \
  && rm -rf /var/cache/apk/*


RUN mkdir /srv/data /srv/plugins /srv/errbackends /app \
    && chown -R $ERR_USER: /srv /app

USER $ERR_USER
WORKDIR /srv

COPY requirements.txt /app/requirements.txt

RUN virtualenv /app/venv
RUN . /app/venv/bin/activate; pip3 install --no-cache-dir -r /app/requirements.txt

COPY config.py /app/config.py
COPY run.sh /app/venv/bin/run.sh

EXPOSE 3141 3142
VOLUME ["/srv"]

CMD ["/app/venv/bin/run.sh"]
