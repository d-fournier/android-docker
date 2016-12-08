FROM openjdk:8-jdk 

MAINTAINER Donovan Fournier "donof43@gmail.com"

ENV ANDROID_SDK_FILENAME tools_r25.2.3-linux.zip
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/${ANDROID_SDK_FILENAME}
ENV ANDROID_API_LEVELS android-25
ENV ANDROID_BUILD_TOOLS_VERSION 25.0.1

# Prepare environment
RUN mkdir /opt
COPY tools /opt/tools
RUN apk update && apk add ca-certificates wget unzip expect && update-ca-certificates

# Download SDK and unzip SDK
RUN cd /opt && \
  wget -O android-sdk.zip --quiet ${ANDROID_SDK_URL} && \
  unzip -q android-sdk.zip -d android-sdk-linux && \
  rm -f android-sdk.zip && \
  chown -R root.root android-sdk-linux && \
  mkdir android-sdk-linux\licenses && \
  echo -e "8933bad161af4178b1185d1a37fbf41ea5269c55\n" > android-sdk-linux\licenses\android-sdk-license && \
  echo -e "84831b9409646a918e30573bab4c9c91346d8abd\n" > android-sdk-linux\licenses\android-sdk-preview-license

# Download SDK dependencies
RUN cd /opt && \
  /opt/tools/android-accept-licenses.sh "android-sdk-linux/tools/android update sdk --all --no-ui --filter platform-tools,build-tools-${ANDROID_BUILD_TOOLS_VERSION},${ANDROID_API_LEVELS},extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services"

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
