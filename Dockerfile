# bud-tls
#
# VERSION               1.0.0

FROM      dockerfile/nodejs
MAINTAINER Joey Baker <joey@byjoeybaker.com>

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -y openssl
RUN npm i -g bud-tls

# add a user for bud to run workers as
RUN adduser --system --disabled-password \
  --home /usr/local/var/lib/couchdb --no-create-home \
  --shell=/bin/bash --group --gecos "" bud

# for some reason things break if using CMD, so we'll just have a script kick off bud
ADD ./start.sh /opt/start.sh
RUN chmod 770 /opt/start.sh

ENTRYPOINT ["/opt/start.sh"]

EXPOSE 443
