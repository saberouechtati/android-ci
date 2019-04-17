#
# GitLab CI: Android v0.1
#
# https://hub.docker.com/r/sabero/android-ci/
#

FROM ubuntu:18.04
MAINTAINER Sabero <saberouechtati@gmail.com>

ENV VERSION_SDK_TOOLS "25.2.2"
ENV VERSION_BUILD_TOOLS "25"
ENV VERSION_TARGET_SDK "25"

ENV SDK_PACKAGES "build-tools-${VERSION_BUILD_TOOLS},android-${VERSION_TARGET_SDK},addon-google_apis-google-${VERSION_TARGET_SDK},platform-tools,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository"

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"
ENV DEBIAN_FRONTEND noninteractive

# Create licenses dir
RUN mkdir -p $ANDROID_HOME/licenses/ \
  && echo -e "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e\n24333f8a63b6825ea9c5514f83c2829b004d1fee" > $ANDROID_HOME/licenses/android-sdk-license \
  && echo -e "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_HOME/licenses/android-sdk-preview-license \
  && echo -e "33b6a2b64607f11b759f320ef9dff4ae5c47d97a" > $ANDROID_HOME/licenses/google-gdk-license \
  && echo -e "601085b94cd77f0b54ff86406957099ebe79c4d6" > $ANDROID_HOME/licenses/android-googletv-license \
  && echo -e "d975f751698a77b662f1254ddbeed3901e976f5a" > $ANDROID_HOME/licenses/intel-android-extra-license \
  && echo -e "e9acab5b5fbb560a72cfaecce8946896ff6aab9d" > $ANDROID_HOME/licenses/mips-android-sysimage-license
  
RUN apt-get -qq update && \
    apt-get install -y -qqy --no-install-recommends \
      sudo
  
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker

RUN sudo apt purge openjdk-9-jdk openjdk-8-jdk java-common

RUN sudo apt-get -qq update && \
    sudo apt-get -o Dpkg::Options::="--force-overwrite" install -y openjdk-8-jdk && \
    sudo apt-get install -y -qqy --no-install-recommends apt-utils \
      ca-certificates-java \
      bzip2 \
      git-core \
      html2text \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses5 \
      lib32z1 \
      unzip \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN sudo /var/lib/dpkg/info/ca-certificates-java.postinst configure
    
ADD http://dl.google.com/android/repository/tools_r${VERSION_SDK_TOOLS}-linux.zip /tools.zip
RUN sudo unzip /tools.zip -d /sdk && \
    sudo rm -v /tools.zip

RUN sudo mkdir -p /root/.android && \
    sudo touch /root/.android/repositories.cfg 

RUN (while [ 1 ]; do sleep 5; echo y; done) | sudo ${ANDROID_HOME}/tools/android update sdk -u -a -t ${SDK_PACKAGES}
