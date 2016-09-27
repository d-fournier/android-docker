FROM ubuntu:16.04

MAINTAINER Donovan Fournier "donof43@gmail.com"
# from https://github.com/appunite/docker

# Install java8
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Deps
RUN apt-get update && apt-get install -y --force-yes expect && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy install tools
COPY tools /opt/tools
ENV PATH ${PATH}:/opt/tools

# Install Android SDK
RUN cd /opt && wget --output-document=android-sdk.tgz --quiet https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
  tar xzf android-sdk.tgz && \
  rm -f android-sdk.tgz && \
  chown -R root.root android-sdk-linux && \
  mkdir android-sdk-linux\licenses && \
  echo -e "8933bad161af4178b1185d1a37fbf41ea5269c55\n" > android-sdk-linux\licenses\android-sdk-license && \
  /opt/tools/android-accept-licenses.sh "android-sdk-linux/tools/android update sdk --all --no-ui --filter platform-tools,tools" && \
  /opt/tools/android-accept-licenses.sh "android-sdk-linux/tools/android update sdk --all --no-ui --filter platform-tools,tools,build-tools-24.0.2,android-24,extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services"

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN which adb
RUN which android

# Cleaning
RUN apt-get clean

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
