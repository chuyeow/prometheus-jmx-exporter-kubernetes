FROM alpine:3.7

COPY support/jmx_prometheus_javaagent-0.3.1.jar /support/jmx_prometheus_javaagent-0.3.1.jar
COPY support/kafka-config.yaml /support/kafka-config.yaml

ENV SHARED_VOLUME_PATH /shared
RUN ["sh", "-c", "mkdir -p $SHARED_VOLUME_PATH"]

CMD ["sh", "-c", "cp -a /support/* $SHARED_VOLUME_PATH"]
