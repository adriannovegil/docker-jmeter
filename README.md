# JMeter Docker

Project for test JMeter over Docker using a Master-Slave architecture

## How to run

Biuld the base image

```shell
$ cd jmeter-base
$ docker build -t jmeter-cluster/jmeter-base .
```
Then, build the rest of the image using `docker-compose`:

```shell
$ docker-compose build
```

Now you can launch the JMeter cluster executing the following command:

```shell
$ docker-compose up
```
## Experiment Definition

  - JMETER_RUN_ID
  - JMETER_RUN_NAME

  - JMETER_TEST_PLAN_FILE_NAME
  - JMETER_TEST_PLAN_URL

  - JMETER_RAMPUP
  - JMETER_THREADS
  - JMETER_DURATION

## References

### JMeter

  * https://github.com/edgexfoundry/performance-test
  * https://github.com/serputko/performance-testing-framework
  * https://developers.redhat.com/blog/2018/11/22/automated-performance-testing-kubernetes-openshift/
  * https://www.blazemeter.com/blog/how-to-use-grafana-to-monitor-jmeter-non-gui-results/?utm_source=blog&utm_medium=BM_blog&utm_campaign=how-to-use-grafana-to-monitor-jmeter-non-gui-results2
  * https://www.blazemeter.com/blog/how-to-use-grafana-to-monitor-jmeter-non-gui-results-part-2/
  * https://www.blazemeter.com/blog/make-use-of-docker-with-jmeter-learn-how/
  * https://www.blazemeter.com/blog/jmeter-distributed-testing-with-docker/
  * https://collabnix.com/running-apache-jmeter-3-1-distributed-load-testing-using-docker-compose-v3-1-swarm-mode/
  * https://github.com/fgiloux/auto-perf-test/tree/master/jmeter/examples
  * https://github.com/apolloclark/jmeter/blob/master/docker-compose.yml
  * https://github.com/vantruongt2/perf
  * https://github.com/mustardgrain/jmeter-utils
  * http://www.vinsguru.com/jmeter-real-time-results-influxdb-grafana/
  * https://github.com/vmarrazzo/docker-jmeter
  * https://jmeter.apache.org/usermanual/jmeter_distributed_testing_step_by_step.pdf
  * https://joko.miraheze.org/wiki/Pruebas_Distribuidas_(Maestro_y_Esclavo)
  * https://medium.com/@vepo/dockerized-jmeter-84228733e306
  * https://github.com/allroundtesters/tester-portal
  * https://github.com/Hitwise/archiso-jmeter
  * https://github.com/rajueswar/azurevmdeploy/tree/8051e8d795c87c2c0428685755f4d7234f3ac964

### Openshift

 * https://github.com/matth4260/JMeterProject/tree/9a2d83ff371ec857e73726b1fa9cd02b6306c7b2
 * https://github.com/eleanordare/jmeter-openshift-jenkins

### Prometheus

 * https://github.com/johrstrom/jmeter-prometheus-plugin

### InfluxDB

  * https://github.com/msfidelis/jmeter-grafana-influxdb
  * https://github.com/NovatecConsulting/JMeter-InfluxDB-Writer
  * https://sfakrudeen78.github.io/JMeter-InfluxDB-Writer/
  * https://medium.com/@ellenhuang523/a-docker-solution-to-jmeter-influxdb-grafana-performance-testing-568848de7a0f
  * https://github.com/swethacts/leapperf

### Grafana

 * https://github.com/bhattchaitanya/Grafana-Dashboard-Generator
 * https://dev.to/shyambh/grafana-for-real-time-jmeter-test-monitoring-39hb
