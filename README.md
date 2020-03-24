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

## References

  * https://www.blazemeter.com/blog/how-to-use-grafana-to-monitor-jmeter-non-gui-results/?utm_source=blog&utm_medium=BM_blog&utm_campaign=how-to-use-grafana-to-monitor-jmeter-non-gui-results2
  * https://www.blazemeter.com/blog/how-to-use-grafana-to-monitor-jmeter-non-gui-results-part-2/
  * https://www.blazemeter.com/blog/make-use-of-docker-with-jmeter-learn-how/
  * https://www.blazemeter.com/blog/jmeter-distributed-testing-with-docker/
  * https://collabnix.com/running-apache-jmeter-3-1-distributed-load-testing-using-docker-compose-v3-1-swarm-mode/
  * https://github.com/fgiloux/auto-perf-test/tree/master/jmeter/examples
  * https://github.com/apolloclark/jmeter/blob/master/docker-compose.yml
