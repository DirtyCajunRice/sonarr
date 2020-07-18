FROM itscontained/mono:6.10.0.104

LABEL maintainer="dirtycajunrice"

RUN \
 # add sonarr repo
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
 echo "deb http://apt.sonarr.tv/ develop main" > /etc/apt/sources.list.d/sonarr.list && \
 # install packages
 apt-get update --allow-insecure-repositories && \
 apt-get install -y --allow-unauthenticated \
	nzbdrone && \
 # cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# ports
EXPOSE 8989

CMD mono --debug Sonarr.exe -nobrowser
