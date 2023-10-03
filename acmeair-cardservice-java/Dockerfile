FROM maven:3.9-ibm-semeru-17-focal AS builder

COPY . /src
ARG build_env
COPY settings.xml /usr/share/maven/ref
WORKDIR /src

#use the proxy defined in settings.xml if building in a disconnected cluster
RUN chmod u+x build.sh && ./build.sh ${build_env}

FROM websphere-liberty:kernel-java11-openj9

COPY --from=builder /src/src/main/liberty/config/server.xml /config/server.xml
COPY --from=builder /src/src/main/liberty/config/server.env /config/server.env
COPY --from=builder /src/src/main/liberty/config/jvm.options /config/jvm.options
COPY --from=builder /src/target/acmeair-cardservice-java-3.1.war /config/apps/

USER 0
RUN chown 1001:0 /config/server.xml
RUN chown 1001:0 /config/server.env
RUN chown 1001:0 /config/jvm.options
RUN chown 1001:0 /config/apps/acmeair-cardservice-java-3.1.war

RUN mkdir /opt/ibm/wlp/etc && \
    echo "proxyHost: 10.20.80.216\nproxyPort: 3128" > /opt/ibm/wlp/etc/repositories.properties && \
    chown -R 1001:0 /opt/ibm/wlp/etc
USER 1001

RUN configure.sh || if [ $? -ne 22 ]; then exit $?; fi


