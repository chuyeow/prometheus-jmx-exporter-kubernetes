# Prometheus JMX Exporter container for Kubernetes

This is a Docker container intended to be run in the same pod as your Java containers, to export their metrics for Prometheus.

The default `CMD` copies over the required [JMX Exporter](https://github.com/prometheus/jmx_exporter) files to the directory specified by the `SHARED_VOLUME_PATH` environment variable.

## Files available

* `$SHARED_VOLUME_PATH/jmx_prometheus_javaagent.jar`: the [JMX Exporter](https://github.com/prometheus/jmx_exporter) javaagent JAR file.
* `$SHARED_VOLUME_PATH/config/*.yaml`: example config files for the exporter.
    * I only bothered to copy over the [example Kafka config from upstream](https://github.com/prometheus/jmx_exporter/blob/master/example_configs/kafka-0-8-2.yml) because that's what I was using.

## Using this as a Kubernetes Init Container

This container is best used as an [Init Container](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

Add this to `initContainers` of your `Deployment` or `StatefulSet`:

```yaml
spec:
  initContainers:
  - name: prometheus-jmx-exporter
    image: spdigital/prometheus-jmx-exporter-kubernetes:0.3.1
    env:
    - name: SHARED_VOLUME_PATH
      value: /shared-volume
    volumeMounts:
    - mountPath: /shared-volume
      name: shared-volume
```

The init container and your Kafka container will share a volume:

```yaml
volumes:
- name: shared-volume
  emptyDir: {}
```

In your Kafka container, set `KAFKA_OPTS` to refer to files placed by the `prometheus-jmx-exporter` container into the shared volume:

```yaml
- name: KAFKA_OPTS
  value: -javaagent:/shared-volume/jmx_prometheus_javaagent.jar=19000:/shared-volume/configs/kafka-config.yaml
```

Don't forget to annotate your resources so Prometheus will scrape your pod's `/metrics` endpoint:

```yaml
annotations:
  "prometheus.io/scrape": "true"
  "prometheus.io/port": "19000"
```
