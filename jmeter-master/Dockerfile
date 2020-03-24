# Jmeter Master Image
FROM jmeter-cluster/jmeter-base

USER root

ENV JMETER_BIN $JMETER_HOME/bin

ENV TEST_DIR default
ENV TEST_PLAN_FILE_NAME test-plan.jmx
ENV CLIENT_ENGINE_PORT 4445
ENV REMOTE_HOSTS 127.0.0.1

# Use a predefined configuration.  This sets the contract for connecting to jmeter servers.
#ADD jmeter.properties /var/lib/apache-jmeter/bin/

# Create mount point for script and log files
VOLUME ["/logs"]

EXPOSE $CLIENT_RMI_PORT
EXPOSE $CLIENT_ENGINE_PORT

# Copy load_tests folder
COPY load_tests /load_tests

# Use a predefined configuration.  This sets the contract for connecting to jmeter servers.
ADD jmeter.properties $JMETER_BIN/

# Copy entrypoint script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

#1001 is an arbitrary choice
#USER 1001

# Run jmeter master
ENTRYPOINT ["/docker-entrypoint.sh"]
