FROM openjdk:8-jdk

MAINTAINER Fournier Donovan "support@dfournier.me"

# Get from Docker argument and set it as environment variable to make it available for other images
ARG ANDROID_COMPILE_SDK=24
ENV ANDROID_COMPILE_SDK=$ANDROID_COMPILE_SDK
ARG ANDROID_BUILD_TOOLS_VERSION=25.0.2
ENV ANDROID_BUILD_TOOLS_VERSION=$ANDROID_BUILD_TOOLS_VERSION

ENV ANDROID_SDK_FILENAME sdk-tools-linux-3859397.zip
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/${ANDROID_SDK_FILENAME}

# Prepare Android SDK directory
RUN mkdir -p /opt/android-sdk-linux/licenses

# ----- START Run all the Android preparation in a single RUN command to reduce image size

# Download SDK and unzip SDK
RUN cd /opt && \
  wget -O android-sdk.zip --quiet ${ANDROID_SDK_URL} && \
  unzip -q android-sdk.zip -d android-sdk-linux && \
  rm -f android-sdk.zip && \
  chown -R root.root android-sdk-linux && \

# Accept licence
  yes | /opt/android-sdk-linux/tools/bin/sdkmanager --licenses && \

# Download SDK dependencies
  /opt/android-sdk-linux/tools/bin/sdkmanager \
    tools \
    platform-tools \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_COMPILE_SDK}" \
    "extras;android;m2repository" \
    "extras;google;m2repository" \
    "extras;google;google_play_services"

# ----- END


# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# GO to workspace
RUN mkdir -p /home/android/workspace
WORKDIR /home/android/workspace


# TODO find a way to avoid this duplication with root Dockerfile


# ----- START Download Emulator Android dependency

# Install system dependencies
RUN apt-get update \
    && apt-get install  -y --no-install-recommends file libmagic1 libglu1-mesa mesa-utils libpci3 pciutils libpulse0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download SDK dependencies
RUN  /opt/android-sdk-linux/tools/bin/sdkmanager \
    "emulator" \
    "system-images;android-${ANDROID_COMPILE_SDK};google_apis;armeabi-v7a"

RUN echo "no" | /opt/android-sdk-linux/tools/bin/avdmanager \
    --verbose create avd \
    --name "Android-test-emulator" \
    --package "system-images;android-${ANDROID_COMPILE_SDK};google_apis;armeabi-v7a" \
    --tag  "google_apis" \
    --abi "armeabi-v7a"

# ----- END
