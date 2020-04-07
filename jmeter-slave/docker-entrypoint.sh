#!/bin/bash
set -e

# Calculate JVM memory right configuration
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

echo "JVM_ARGS=${JVM_ARGS}"

# Get host information
HOST_NAME=$(hostname)
IP_ADD=$(hostname -i)

# Show execution information
export START_EVENT_JSON_STRING="{ \
  \"LOAD_TEST_EVENT_TYPE\": \"start-jmeter-slave\", \
  \"LOAD_TEST_COMPONENT\": \"jmeter-slave\", \
  \"HOST_NAME\": \"${HOST_NAME}\", \
  \"IP_ADD\": \"${IP_ADD}\", \
  \"JVM_ARGS\": \"${JVM_ARGS}\", \
  \"JMETER_SERVER_RMI_PORT\": \"${JMETER_SERVER_RMI_PORT}\", \
  \"JMETER_CLIENT_RMI_PORT\": \"${JMETER_CLIENT_RMI_PORT}\", \
  \"JMETER_VERSION\": \"${JMETER_VERSION}\", \
  \"JMETER_HOME\": \"${JMETER_HOME}\", \
  \"JMETER_BIN\": \"${JMETER_BIN}\" \
}"

echo "--> slave-$EXP_RUN_ID - Start JMeter Slave Event: $START_EVENT_JSON_STRING"

# Start time
JMETER_START_TIME=$(date)
LOG_TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "--> slave-EXP_RUN_ID - Starting the JMeter Engine at this time \"$JMETER_START_TIME\""

# Execute Jmeter
$JMETER_BIN/jmeter \
    -n -s \
    -Jclient.rmi.localport=${JMETER_SERVER_RMI_PORT} \
    -Jserver.rmi.localport=${JMETER_CLIENT_RMI_PORT} \
    -Jserver.rmi.ssl.disable=true \
		-j /logs/slave_${LOG_TIMESTAMP}_${IP_ADD:9:3}.log
