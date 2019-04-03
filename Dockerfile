#
# GitLab CI: Android v0.1
#
# https://hub.docker.com/r/sabero/android-ci/
#

FROM ubuntu:16.04
MAINTAINER Sucipto <chip@pringstudio.com>

ENV VERSION_SDK_TOOLS "25.2.2"
ENV VERSION_BUILD_TOOLS "25"
ENV VERSION_TARGET_SDK "25"

ENV SDK_PACKAGES "build-tools-${VERSION_BUILD_TOOLS},android-${VERSION_TARGET_SDK},addon-google_apis-google-${VERSION_TARGET_SDK},platform-tools,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository"

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"
ENV DEBIAN_FRONTEND noninteractive

# Create licenses dir
RUN mkdir -p $ANDROID_HOME/licenses/

RUN apt-get -qq update && \    
    apt-get install -y -qqy --no-install-recommends apt-utils \
      openjdk-9-jdk \
      curl \
      html2text \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses5 \
      lib32z1 \
      unzip \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

ADD http://dl.google.com/android/repository/tools_r${VERSION_SDK_TOOLS}-linux.zip /tools.zip
RUN unzip /tools.zip -d /sdk && \
    rm -v /tools.zip

RUN (while [ 1 ]; do sleep 5; echo y; done) | ${ANDROID_HOME}/tools/android update sdk -u -a -t ${SDK_PACKAGES}
