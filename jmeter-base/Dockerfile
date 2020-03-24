FROM fabric8/java-centos-openjdk8-jdk:1.4

LABEL jmeter.version="5.2.1"
ENV JMETER_VERSION 5.2.1

# Set JMeter base
ENV JMETER_BASE /opt/jmeter
# Set working directory
WORKDIR $JMETER_BASE

############# Dockerize
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh wait-for-it.sh
RUN chmod +x wait-for-it.sh

ENV DOCKERIZE_VERSION v0.6.1
ADD https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz dockerize.tar.gz
RUN tar xzf dockerize.tar.gz
RUN chmod +x dockerize
RUN rm dockerize.tar.gz

# Create jmeter directory with tests and results folder and install JMeter
# If you don't have internet access from the build machine use COPY instead of curl:
# COPY binaries/apache-jmeter-${JMETER_VERSION}.tgz $JMETER_BASE
RUN mkdir -p $JMETER_BASE/{tests,results} \
    && curl -SL https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
    | tar -xzC $JMETER_BASE \
    && rm -rf apache-jmeter-${JMETER_VERSION}.tgz

############# ARE PLUGINS NEEDED?
# COPY binaries/JMeterPlugins-ExtrasLibs-1.${JMETER_VERSION}.zip $JMETER_BASE/apache-jmeter-${JMETER_VERSION}/

# Set JMeter home
ENV JMETER_HOME $JMETER_BASE/apache-jmeter-${JMETER_VERSION}

# Add JMeter to the Path
ENV PATH $JMETER_HOME/bin:$PATH

# Additional jars (ex. AMQP driver) can be copied into $JMETER_HOME/lib
COPY lib/* $JMETER_HOME/lib/
COPY lib/ext/* $JMETER_HOME/lib/ext/

# Copy custom user.properties file for reports dashboard to be generated
# COPY user.properties $JMETER_HOME/bin/user.properties

RUN chgrp -R 0 $JMETER_BASE
RUN chmod -R g+rw $JMETER_BASE

#1001 is an arbitrary choice
USER 1001

ENTRYPOINT /bin/sh
