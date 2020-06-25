FROM registry.redhat.io/fuse7/fuse-java-openshift

# For Java 8, try this
#FROM registry.redhat.io/ubi8/openjdk-8


#FROM registry.redhat.io/fuse7/fuse-java-openshift@sha256:00be8b1454a69b5c01bd0ef3ee9b26eac7425445cd960870856ccb846b070ee1

# For Java 11, try this
#FROM adoptopenjdk/openjdk11:alpine-jre

# Refer to Maven build -> finalName
ARG JAR_FILE=target/rest-http-1.5.19-7-SNAPSHOT.jar

# cd /opt/app
WORKDIR /opt/app

USER root

RUN subscription-manager repos --enable "rhel-*-optional-rpms" --enable "rhel-*-extras-rpms"

RUN yum -y install wget unzip

RUN wget https://www.yourkit.com/download/docker/YourKit-JavaProfiler-2019.8-docker.zip -P /tmp/ && \
  unzip /tmp/YourKit-JavaProfiler-2019.8-docker.zip -d /usr/local && \
  rm /tmp/YourKit-JavaProfiler-2019.8-docker.zip

# cp target/spring-boot-web.jar /opt/app/app.jar
COPY ${JAR_FILE} app.jar

EXPOSE 10001

# use this for running the debugger...
#ENV JAVA_TOOL_OPTIONS -agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n

#use this for runnning the profiler...
ENV JAVA_TOOL_OPTIONS -agentpath:/usr/local/YourKit-JavaProfiler-2019.8/bin/linux-x86-64/libyjpagent.so=port=10001,listen=all

# java -jar /opt/app/app.jar
ENTRYPOINT ["java","-jar","app.jar"]
