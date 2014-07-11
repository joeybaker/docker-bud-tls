# bud-tls
#
# VERSION               0.0.1

FROM      dockerfile/nodejs
MAINTAINER Joey Baker <joey@byjoeybaker.com>

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -y openssl
RUN npm i -g bud-tls
