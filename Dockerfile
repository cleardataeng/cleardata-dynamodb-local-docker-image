FROM debian:stretch

ENV SHA256SUM d79732d7cd6e4b66fbf4bb7a7fc06cb75abbbe1bbbfb3d677a24815a1465a0b2
ENV DYNAMO_VER latest
ENV JAVA_OPS ""
ENV PORT 8000

ADD https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_${DYNAMO_VER}.tar.gz /tmp/dynamodb_local.tar.gz

RUN echo "${SHA256SUM}  /tmp/dynamodb_local.tar.gz" | sha256sum -c --strict && \
    useradd -d /data -m user && \
    tar zxvf /tmp/dynamodb_local.tar.gz -C /data && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
					       dumb-init \
					       openjdk-8-jre-headless

USER user
WORKDIR /data
VOLUME ["/data"]
EXPOSE 8000

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD /usr/bin/java ${JAVA_OPTS} -Djava.library.path=. -jar DynamoDBLocal.jar --sharedDb -dbPath /data -port ${PORT}
