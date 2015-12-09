FROM taskurotta/java:8
MAINTAINER Taskurotta <taskurotta@googlegroups.com>

# Install https://github.com/jrudolph/perf-map-agent
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get update \ 
	&& apt-get install -y --force-yes --no-install-recommends git g++ make cmake ca-certificates \
	&& cd ~ \
	&& git clone --depth=1 https://github.com/jrudolph/perf-map-agent \
	&& cd perf-map-agent && cmake . \
	&& make \
	&& echo "#!/bin/bash" >> /usr/local/bin/jperf-map.sh \
	&& echo "set -e" >> /usr/local/bin/jperf-map.sh \
	&& echo "cd ~/perf-map-agent/out" >> /usr/local/bin/jperf-map.sh \
	&& echo "java -cp attach-main.jar:$JAVA_HOME/lib/tools.jar net.virtualvoid.perf.AttachOnce 1" >> /usr/local/bin/jperf-map.sh \
	&& chmod +x /usr/local/bin/jperf-map.sh \
	&& apt-get remove -y --purge git g++ make cmake ca-certificates \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists 

