FROM itscontained/mono:6.10.0.104
MAINTAINER dirtycajunrice

ARG VERSION
ENV DEBIAN_FRONTEND="noninteractive"

RUN \
 # Install prereqs
 curl -so /tmp/packages-microsoft-prod.deb \
   https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && \
 dpkg -i /tmp/packages-microsoft-prod.deb && \
 apt update && \
 apt install curl mediainfo ca-certificates dotnet-sdk-3.1 -y --no-install-recommends && \
 # install app
 curl -Lso /tmp/radarr.tar.gz \
    "https://radarr.lidarr.audio/v1/update/aphrodite/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=x64" && \
 mkdir -p /opt/Radarr/bin && \
 tar ixzf /tmp/radarr.tar.gz -C /opt/Radarr/bin --strip-components 1 && \
 # cleanup
 apt-get clean && \
 rm -rf \
        /app/radarr/bin/Radarr.Update \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/* && \
 # make package info
 echo "UpdateMethod=docker\nBranch=aphrodite\nPackageVersion=${VERSION}\nPackageAuthor=[Team itscontained](https://github.com/itscontained)" > /opt/Radarr/package_info

# ports
EXPOSE 7878

CMD /opt/Radarr/bin/Radarr -nobrowser
