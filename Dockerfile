# DOCKER-VERSION 1.6.2
#
# TeamCity Agent with NodeJS Dockerfile
#
# https://github.com/richardkdrew/docker-teamcity-agent-node
#
FROM richardkdrew/teamcity-agent

MAINTAINER Richard Drew <richardkdrew@gmail.com>

USER root

# install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        git \
        ca-certificates \
# install node and npm
	&& NODE_VERSION=0.12.7 \
	&& NPM_VERSION=2.11.3 \
# verify gpg and sha256: http://nodejs.org/dist/v0.10.30/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
	&& gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D \
	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --verify SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& npm install -g npm@"$NPM_VERSION" \
# install Bower
	&& npm install -g bower \
# do some clean-up
	&& rm -rf /var/lib/apt/lists/* \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& npm cache clear

# run the TeamCity Agent
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

USER teamcity

VOLUME ["/home/teamcity"]

ENTRYPOINT ["/docker-entrypoint.sh"]