FROM alpine:3.13.5

COPY files/jmx_prometheus_javaagent-0.15.0.jar /files/jmx_prometheus_javaagent.jar
COPY files/configs/* /files/configs/

ENV SHARED_VOLUME_PATH /shared
RUN ["sh", "-c", "mkdir -p $SHARED_VOLUME_PATH"]

CMD ["sh", "-c", "cp -a /files/* $SHARED_VOLUME_PATH"]

