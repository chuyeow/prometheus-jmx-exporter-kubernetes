# Prometheus JMX Exporter container for Kubernetes

This is a Docker container intended to be run in the same pod as your Java containers, to export their metrics for Prometheus.

The default `CMD` copies over the required [JMX Exporter](https://github.com/prometheus/jmx_exporter) files to the directory specified by the `SHARED_VOLUME_PATH` environment variable.
