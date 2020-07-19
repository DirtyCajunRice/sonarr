FROM itscontained/mono:6.10.0.104
MAINTAINER dirtycajunrice

ARG VERSION

ENV DEBIAN_FRONTEND=noninteractive \
    UMASK=0002

RUN \
 # add sonarr repo
 apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 2009837CBFFD68F45BC180471F4F90DE2A9B4BF8 && \
 echo "deb http://apt.sonarr.tv/ubuntu focal-develop main" > /etc/apt/sources.list.d/sonarr.list && \
 # create user/group
 adduser sonarr \
   --uid 567 \
   --group \
   --system \
   --disabled-password \
   --no-create-home && \
 # install packages
 apt update && \
 apt install -y sonarr=${VERSION} && \
 # cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/* && \
 # modify package info
 sed -i 's,Author.*,Author=[Team itscontained](https://github.com/itscontained),;s/apt/docker/' \
    /usr/lib/sonarr/package_info && \
 # set umask for exec login
 echo umask ${UMASK} >> /etc/bash.bashrc

# ports
EXPOSE 8989

# set default user
USER sonarr:sonarr

# Convenience dir
WORKDIR /var/lb/radarr

# Run sonarr with umask set
CMD umask ${UMASK} && mono --debug /usr/lib/sonarr/bin/Sonarr.exe -nobrowser -data=/var/lib/sonarr
