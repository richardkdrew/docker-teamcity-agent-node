#!/bin/bash

if [ ! -d /opt/TeamCity/buildAgent ]; then
	mkdir -p /opt/TeamCity/buildAgent \
		&& cd /opt/TeamCity/buildAgent \
		&& wget $TEAMCITY_URL/update/buildAgent.zip \
		&& unzip buildAgent.zip \
		&& rm buildAgent.zip \
		&& cp conf/buildAgent{.dist,}.properties \
		&& sed -i 's#^\(serverUrl=\).*$#\1'$TEAMCITY_URL'#' conf/buildAgent.properties \
		&& sed -i 's#^\(name=\).*$#\1'$AGENT_NAME'#' conf/buildAgent.properties \
		&& chmod a+x /opt/TeamCity/buildAgent/bin/agent.sh
fi
exec /opt/TeamCity/buildAgent/bin/agent.sh run