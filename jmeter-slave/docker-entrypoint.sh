#!/bin/bash
set -e

# Calculate JVM memory configuration
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
echo "jmeter args=$@"

export START_EVENT_JSON_STRING="{ \
  \"LOAD_TEST_EVENT_TYPE\": \"start-jmeter-slave\", \
  \"LOAD_TEST_COMPONENT\": \"jmeter-slave\", \
  \"SERVER_HOST_NAME\": \"${SERVER_HOST_NAME}\", \
  \"SERVER_RMI_PORT\": \"${SERVER_RMI_PORT}\", \
  \"CLIENT_RMI_PORT\": \"${CLIENT_RMI_PORT}\", \
  \"JMETER_VERSION\": \"${JMETER_VERSION}\", \
  \"JMETER_HOME\": \"${JMETER_HOME}\", \
  \"JMETER_BIN\": \"${JMETER_BIN}\" \
}"
echo "--> Start JMeter Slave Event:  $START_EVENT_JSON_STRING"

# Start time
JMETER_START_TIME=$(date)
LOG_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
IP_ADD=$(hostname -i)
echo "--> slave - Starting the JMeter Engine at this time \"$JMETER_START_TIME\""

# Execute Jmeter
$JMETER_BIN/jmeter \
    -n -s \
    -Jclient.rmi.localport=${SERVER_RMI_PORT} \
    -Jserver.rmi.localport=${CLIENT_RMI_PORT} \
    -Jserver.rmi.ssl.disable=true \
		-j /logs/slave_${LOG_TIMESTAMP}_${IP_ADD:9:3}.log
