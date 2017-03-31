FROM openjdk:8-jdk

MAINTAINER Fournier Donovan "support@dfournier.me"

ARG ANDROID_COMPILE_SDK=24
ARG ANDROID_BUILD_TOOLS_VERSION=25.0.2

ENV ANDROID_SDK_FILENAME tools_r25.2.3-linux.zip
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/${ANDROID_SDK_FILENAME}

# Download SDK and unzip SDK
RUN cd /opt && \
  wget -O android-sdk.zip --quiet ${ANDROID_SDK_URL} && \
  unzip -q android-sdk.zip -d android-sdk-linux && \
  rm -f android-sdk.zip && \
  chown -R root.root android-sdk-linux



# Accept licence to update
RUN mkdir /opt/android-sdk-linux/licenses && \
  echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > /opt/android-sdk-linux/licenses/android-sdk-license && \
  echo "84831b9409646a918e30573bab4c9c91346d8abd" > /opt/android-sdk-linux/licenses/android-sdk-preview-license

# Update tools to get license option
RUN /opt/android-sdk-linux/tools/bin/sdkmanager tools
# Accept licence
RUN yes | /opt/android-sdk-linux/tools/bin/sdkmanager --licenses


# Download SDK dependencies
RUN /opt/android-sdk-linux/tools/bin/sdkmanager \
  tools \
  platform-tools \
  "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
  "platforms;android-${ANDROID_COMPILE_SDK}" \
  "extras;android;m2repository" \
  "extras;google;m2repository" \
  "extras;google;google_play_services"

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# GO to workspace
RUN mkdir -p /home/android/workspace
WORKDIR /home/android/workspace
