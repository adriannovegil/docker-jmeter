# Jmeter Slave Image
FROM jmeter-cluster/jmeter-base

USER root

# Configure JMeter installation
ENV JMETER_BIN $JMETER_HOME/bin
ENV JMETER_SERVER_RMI_PORT 7000
ENV JMETER_CLIENT_RMI_PORT 60000

# Expose access to logs
VOLUME [ "/logs" ]

EXPOSE $CLIENT_ENGINE_PORT

# Use a predefined configuration.  This sets the contract for connecting to jmeter servers.
ADD jmeter.properties $JMETER_BIN/

# Inject the inspectIT agent
RUN sed -i 's|-jar|-javaagent:/agent/inspectit-ocelot-agent.jar -jar|g' $JMETER_BIN/jmeter

# Copy entrypoint script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Run jmeter node
ENTRYPOINT ["/docker-entrypoint.sh"]
