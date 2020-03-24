# Jmeter Slave Image
FROM jmeter-cluster/jmeter-base

USER root

ENV JMETER_BIN $JMETER_HOME/bin

#ENV SERVER_HOST_NAME 127.0.0.1
#ENV CLIENT_RMI_PORT 1099
ENV SERVER_RMI_PORT 7000

#ADD jmeter.properties /var/lib/apache-jmeter/bin/

# Expose access to logs
VOLUME [ "/logs" ]

#EXPOSE $SERVER_RMI_PORT
EXPOSE $CLIENT_ENGINE_PORT

# Use a predefined configuration.  This sets the contract for connecting to jmeter servers.
ADD jmeter.properties $JMETER_BIN/

# Copy entrypoint script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

#1001 is an arbitrary choice
#USER 1001

# Run jmeter node
ENTRYPOINT ["/docker-entrypoint.sh"]
