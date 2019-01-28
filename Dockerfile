#
# GitLab CI: Android v0.2
#
# https://hub.docker.com/r/showcheap/gitlab-ci-android/
#

FROM ubuntu:16.04
MAINTAINER Sucipto <chip@pringstudio.com>

ENV VERSION_SDK_TOOLS "4333796"
ENV VERSION_BUILD_TOOLS "28.0.3"
ENV VERSION_TARGET_SDK "28"

ENV SDK_PACKAGES "build-tools-${VERSION_BUILD_TOOLS},android-${VERSION_TARGET_SDK},addon-google_apis-google-${VERSION_TARGET_SDK},platform-tools,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository,sys-img-x86-android-${VERSION_TARGET_SDK},sys-img-x86-google_apis-${VERSION_TARGET_SDK}"

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"
ENV DEBIAN_FRONTEND noninteractive

# Accept License

# Constraint Layout / [Solver for ConstraintLayout 1.0.0-alpha8, ConstraintLayout for Android 1.0.0-alpha8]
RUN mkdir -p $ANDROID_HOME/licenses/
# RUN echo -e "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license
RUN echo -e "24333f8a63b6825ea9c5514f83c2829b004d1fee" > $ANDROID_HOME/licenses/android-sdk-license
RUN echo -e "84831b9409646a918e30573bab4c9c91346d8abd" > $ANDROID_HOME/licenses/android-sdk-preview-license
RUN echo -e "33b6a2b64607f11b759f320ef9dff4ae5c47d97a" > $ANDROID_HOME/licenses/google-gdk-license
RUN echo -e "601085b94cd77f0b54ff86406957099ebe79c4d6" > $ANDROID_HOME/licenses/android-googletv-license
RUN echo -e "d975f751698a77b662f1254ddbeed3901e976f5a" > $ANDROID_HOME/licenses/intel-android-extra-license
RUN echo -e "e9acab5b5fbb560a72cfaecce8946896ff6aab9d" > $ANDROID_HOME/licenses/mips-android-sysimage-license

RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
      curl \
      html2text \
      openjdk-8-jdk \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses5 \
      lib32z1 \
      unzip \
      qtbase5-dev \
      qtdeclarative5-dev \
      wget \
      qemu-kvm \
      build-essential \
      python2.7 \
      python2.7-dev \
      yamdi \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN wget -nv https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip && unzip sdk-tools-linux-${VERSION_SDK_TOOLS}.zip -d /sdk && \
    rm -v sdk-tools-linux-${VERSION_SDK_TOOLS}.zip

RUN wget -nv https://pypi.python.org/packages/1e/8e/40c71faa24e19dab555eeb25d6c07efbc503e98b0344f0b4c3131f59947f/vnc2flv-20100207.tar.gz && tar -zxvf vnc2flv-20100207.tar.gz && rm vnc2flv-20100207.tar.gz && \
    cd vnc2flv-20100207 && ln -s /usr/bin/python2.7 /usr/bin/python && python setup.py install

RUN mkdir /sdk/tools/keymaps && \
    touch /sdk/tools/keymaps/en-us

RUN mkdir /helpers

COPY wait-for-avd-boot.sh /helpers

RUN (while [ 1 ]; do sleep 5; echo y; done) | ${ANDROID_HOME}/tools/android update sdk -u -a -t ${SDK_PACKAGES}
