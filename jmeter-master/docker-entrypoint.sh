#!/bin/bash
set -e

# Calculate JVM memory configuration
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

export FULL_LOAD_TEST_DIR=/load_tests/testplan/${TEST_DIR}

# Validate if exist any test plan
if [ ! -f "${FULL_LOAD_TEST_DIR}/${TEST_PLAN_FILE_NAME}" ]
then
	(>&2 echo "--> master -Error executing Jmeter Script:  Test Plan File is not found:  '${FULL_LOAD_TEST_DIR}/${TEST_PLAN_FILE_NAME}'.  Possible causes.  A) TEST_PLAN_URL may be invalid...check it.  B) Test Plan does not exist in container.")
    exit -1;
fi

echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
echo "jmeter args=$@"

export START_EVENT_JSON_STRING="{ \
  \"LOAD_TEST_EVENT_TYPE\": \"start-jmeter-master\", \
  \"LOAD_TEST_COMPONENT\": \"jmeter-master\", \
  \"SERVER_HOST_NAME\": \"${SERVER_HOST_NAME}\", \
  \"SERVER_RMI_PORT\": \"${SERVER_RMI_PORT}\", \
  \"CLIENT_RMI_PORT\": \"${CLIENT_RMI_PORT}\", \
  \"CLIENT_ENGINE_PORT\": \"${CLIENT_ENGINE_PORT}\", \
  \"REMOTE_HOSTS\": \"${REMOTE_HOSTS}\", \
  \"TEST_PLAN_FILE_NAME\": \"${TEST_PLAN_FILE_NAME}\", \
  \"JMETER_VERSION\": \"${JMETER_VERSION}\", \
  \"JMETER_HOME\": \"${JMETER_HOME}\", \
  \"JMETER_BIN\": \"${JMETER_BIN}\" \
}"
echo "--> Start JMeter Master Event:  $START_EVENT_JSON_STRING"

# Start time
JMETER_START_TIME=$(date)
LOG_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
IP_ADD=$(hostname -i)
echo "--> master - Starting the JMeter Engine at this time \"$JMETER_START_TIME\" with this test plan:  \"${FULL_LOAD_TEST_DIR}/${TEST_PLAN_FILE_NAME}\""

# Execute Jmeter
$JMETER_BIN/jmeter \
    -n -X \
    -Jserver.rmi.localport=${CLIENT_RMI_PORT} \
		-R"${REMOTE_HOSTS}" \
		-t "${FULL_LOAD_TEST_DIR}/${TEST_PLAN_FILE_NAME}" \
    -Jserver.rmi.ssl.disable=true \
		-j /logs/master_${LOG_TIMESTAMP}_${IP_ADD:9:3}.log

# End time
JMETER_END_TIME=$(date)
JMETER_EXEC_DURATION=$(date -d @$(( $(date -d "$JMETER_END_TIME" +%s) - $(date -d "$JMETER_START_TIME" +%s) )) -u +'%H:%M:%S')
echo "--> master - \JMeter Engine ended at this time \"$JMETER_END_TIME\".  It ran for this duration:  \"$JMETER_EXEC_DURATION\""
