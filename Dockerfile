FROM itscontained/mono:6.8.0.105

ARG SONARR_VERSION
LABEL maintainer="dirtycajunrice"

ENV SONARR_BRANCH="phantom-develop"

RUN \
 echo "**** install prereqs ****" && \
 apt-get update && apt-get install -y curl sqlite3 mediainfo && \
 echo "**** install sonarr ****" && \
 mkdir -p /usr/lib/sonarr/bin && \
  if [ -z ${SONARR_VERSION+x} ]; then \
	SONARR_VERSION=$(curl -sX GET https://services.sonarr.tv/v1/download/${SONARR_BRANCH}?version=3 | cut -d\" -f4); \
 fi && \
 curl -o /tmp/sonarr.tar.gz -L \
	"https://download.sonarr.tv/v3/${SONARR_BRANCH}/${SONARR_VERSION}/Sonarr.${SONARR_BRANCH}.${SONARR_VERSION}.linux.tar.gz" && \
 tar xf /tmp/sonarr.tar.gz -C /usr/lib/sonarr/bin --strip-components=1 && \
 echo "UpdateMethod=docker\nBranch=${SONARR_BRANCH}\nPackageVersion=${SONARR_VERSION}\nPackageAuthor=itscontained" > /usr/lib/sonarr/package_info && \
 rm -rf /usr/lib/sonarr/bin/Sonarr.Update && \
 echo "**** cleanup ****" && \
 apt-get clean && rm -rf /tmp/* /var/tmp/*

# ports and volumes
EXPOSE 8989

WORKDIR /usr/lib/sonarr/bin/

CMD mono --debug Sonarr.exe -nobrowser
