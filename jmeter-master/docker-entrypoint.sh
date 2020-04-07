#!/bin/bash
set -e

# Calculate JVM memory right configuration
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

# Define FULL_LOAD_TEST_DIR
if [[ ! -e $ROOT_LOAD_DIR ]]; then
    mkdir -p $ROOT_LOAD_DIR
elif [[ ! -d $ROOT_LOAD_DIR ]]; then
    echo "$ROOT_LOAD_DIR already exists but is not a directory" 1>&2
fi
export FULL_LOAD_TEST_DIR=/${ROOT_LOAD_DIR}

# If no experiment id generate one
if ! [ -z "${EXP_RUN_ID}" ]
then
	EXP_RUN_ID=$(date +%s)
fi

# If no start time, set timestamp
if ! [ -z "${EXP_TEST_START_TIME}" ]
then
	EXP_TEST_START_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
fi

# Get host information
HOST_NAME=$(hostname)
IP_ADD=$(hostname -i)

# Get the remote plan
if ! [ -z "${EXP_TEST_PLAN_URL}" ]
then
	# Git case
	echo "--> server-$EXP_RUN_ID - about to download test script.  Cloning from this URL:  \"${EXP_TEST_PLAN_URL}\" to this destination file:  \"${FULL_LOAD_TEST_DIR}/${EXP_TEST_PLAN_FILE_NAME}\""
	git clone ${EXP_TEST_PLAN_URL} ${FULL_LOAD_TEST_DIR}/
	FULL_LOAD_TEST_DIR=${FULL_LOAD_TEST_DIR}/`basename $EXP_TEST_PLAN_URL`
	echo "--> server-$EXP_RUN_ID - git returned with exit code:  $?"
fi

# Add the plan folder to the full path
if [ -z "$EXP_TEST_PLAN_DIR" ]
then
      echo "\--> server-$EXP_RUN_ID - EXP_TEST_PLAN_DIR var is empty"
else
      FULL_LOAD_TEST_DIR=${FULL_LOAD_TEST_DIR}/${EXP_TEST_PLAN_DIR}
fi

# Show execution information
export START_EVENT_JSON_STRING="{ \
  \"LOAD_TEST_EVENT_TYPE\": \"start-jmeter-master\", \
  \"LOAD_TEST_COMPONENT\": \"jmeter-master\", \
  \"HOST_NAME\": \"${HOST_NAME}\", \
  \"IP_ADD\": \"${IP_ADD}\", \
	\"JVM_ARGS\": \"${JVM_ARGS}\", \
  \"JMETER_CLIENT_RMI_PORT\": \"${JMETER_CLIENT_RMI_PORT}\", \
  \"JMETER_CLIENT_ENGINE_PORT\": \"${JMETER_CLIENT_ENGINE_PORT}\", \
  \"JMETER_REMOTE_HOSTS\": \"${JMETER_REMOTE_HOSTS}\", \
	\"JMETER_VERSION\": \"${JMETER_VERSION}\", \
  \"JMETER_HOME\": \"${JMETER_HOME}\", \
  \"JMETER_BIN\": \"${JMETER_BIN}\", \
  \"EXP_RUN_ID\": \"${EXP_RUN_ID}\", \
  \"EXP_RUN_NAME\": \"${EXP_RUN_NAME}\", \
  \"EXP_START_TIME\": \"${EXP_START_TIME}\", \
	\"EXP_TEST_PLAN_URL\": \"${EXP_TEST_PLAN_URL}\", \
	\"EXP_TEST_PLAN_DIR\": \"${EXP_TEST_PLAN_DIR}\", \
	\"FULL_LOAD_TEST_DIR\": \"${FULL_LOAD_TEST_DIR}\", \
  \"EXP_TEST_PLAN_FILE_NAME\": \"${EXP_TEST_PLAN_FILE_NAME}\" \
}"
echo "--> master-$EXP_RUN_ID - Start JMeter Master Event: $START_EVENT_JSON_STRING"

# Start time
JMETER_START_TIME=$(date)
LOG_TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# TODO: Revisar esta línea ya que indica el fichero. Aquí es donde hay que meter el bucle.
echo "--> master-$EXP_RUN_ID - Starting the JMeter Engine at this time \"$JMETER_START_TIME\" with this test plan:  \"${FULL_LOAD_TEST_DIR}/${EXP_TEST_PLAN_FILE_NAME}\""

if [ ! -f "${FULL_LOAD_TEST_DIR}/${EXP_TEST_PLAN_FILE_NAME}" ]
then
	(>&2 echo "--> master -Error executing Jmeter Script:  Test Plan File is not found:  '${FULL_LOAD_TEST_DIR}/${EXP_TEST_PLAN_FILE_NAME}'.  Possible causes.  A) No TEST_PLAN_URL passed in.  B) TEST_PLAN_URL may be invalid...check it.  C) Test Plan does not exist in container.")
    exit -1;
fi

# Execute Jmeter
$JMETER_BIN/jmeter \
    -n -X \
    -Jserver.rmi.localport=${JMETER_CLIENT_RMI_PORT} \
		-R"${JMETER_REMOTE_HOSTS}" \
		-t "${FULL_LOAD_TEST_DIR}/${EXP_TEST_PLAN_FILE_NAME}" \
    -Jserver.rmi.ssl.disable=true \
		-j /logs/master_${LOG_TIMESTAMP}_${IP_ADD:9:3}.log

# End time
JMETER_END_TIME=$(date)
JMETER_EXEC_DURATION=$(date -d @$(( $(date -d "$JMETER_END_TIME" +%s) - $(date -d "$JMETER_START_TIME" +%s) )) -u +'%H:%M:%S')
echo "--> master-$EXP_RUN_ID - \JMeter Engine ended at this time \"$JMETER_END_TIME\".  It ran for this duration:  \"$JMETER_EXEC_DURATION\""
