FROM itscontained/mono:6.10.0.104
MAINTAINER dirtycajunrice

ENV DEBIAN_FRONTEND="noninteractive"

RUN \
 # add sonarr repo
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 2009837CBFFD68F45BC180471F4F90DE2A9B4BF8 && \
 echo "deb http://apt.sonarr.tv/ubuntu focal-develop main" > /etc/apt/sources.list.d/sonarr.list && \
 # install packages
 apt update && \
 apt install -y sonarr && \
 # cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# ports
EXPOSE 8989

CMD mono --debug /usr/lib/sonarr/bin/Sonarr.exe mono -nobrowser
