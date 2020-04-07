# Jmeter Master Image
FROM jmeter-cluster/jmeter-base

USER root

# Install usefull dependencies
RUN yum --quiet install -y git; yum clean all

# Base test dir
ENV ROOT_LOAD_DIR=load_tests

# Configure JMeter installation
ENV JMETER_BIN $JMETER_HOME/bin
ENV JMETER_CLIENT_RMI_PORT=60000
ENV JMETER_CLIENT_ENGINE_PORT 4445
ENV JMETER_REMOTE_HOSTS 127.0.0.1

# Create mount point for script and log files
VOLUME ["/logs"]

EXPOSE $JMETER_CLIENT_RMI_PORT
EXPOSE $JMETER_CLIENT_ENGINE_PORT

COPY load_tests /load_tests

# Use a predefined configuration.  This sets the contract for connecting to jmeter servers.
ADD jmeter.properties $JMETER_BIN/

# Inject the inspectIT agent
RUN sed -i 's|-jar|-javaagent:/agent/inspectit-ocelot-agent.jar -jar|g' $JMETER_BIN/jmeter

# Copy entrypoint script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Run jmeter master
ENTRYPOINT ["/docker-entrypoint.sh"]
