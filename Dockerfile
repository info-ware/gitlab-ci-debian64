FROM debian:buster

RUN apt-get update 
RUN apt-get install -y build-essential devscripts cmake
RUN apt-get install -y gcc g++  
RUN apt-get install -y debhelper dh-systemd dh-exec pkg-config 
RUN apt-get install -y libtool autoconf
RUN apt-get install -y git
RUN apt-get install -y libasound2-dev libgles2-mesa-dev libboost-all-dev 

RUN mkdir -m 0750 /root/.android
RUN apt-get install -y bzip2 curl git-core html2text libc6-i386 lib32stdc++6 
RUN apt-get install -y lib32gcc1 lib32z1 unzip openssh-client sshpass lftp 
RUN apt-get install -y doxygen doxygen-latex graphviz 
RUN apt-get install -y wget ccache joe maven default-jdk binutils-i686-linux-gnu
            
# Correction needed for java certificates
RUN dpkg --purge --force-depends ca-certificates-java
RUN apt-get install -y ca-certificates-java

# clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# ------------------------------------------------------
# --- Android NDK
# ------------------------------------------------------

ENV ANDROID_NDK_VERSION="r18b"
ENV ANDROID_NDK_HOME=/opt/android-ndk

# download
RUN mkdir /opt/android-ndk-tmp
RUN cd /opt/android-ndk-tmp
RUN wget  https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
# uncompress
RUN unzip android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
# move to its final location
RUN mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME}
# remove temp dir
RUN cd ${ANDROID_NDK_HOME}
RUN rm -rf /opt/android-ndk-tmp

# ------------------------------------------------------
# --- Android SDK
# ------------------------------------------------------
# must be updated in case of new versions set 
#ENV VERSION_SDK_TOOLS="4333796"
ENV VERSION_SDK_TOOLS=6858069
ENV ANDROID_HOME="/sdk"
ENV ANDROID_SDK_ROOT="/sdk"

RUN rm -rf /sdk
#RUN wget https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip  -O sdk.zip 
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-${VERSION_SDK_TOOLS}_latest.zip -O sdk.zip
RUN unzip sdk.zip -d /sdk 
RUN rm -v sdk.zip

RUN mkdir -p ${ANDROID_HOME}/licenses/ && echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license && echo "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_HOME/licenses/android-sdk-preview-license

ADD packages.txt /sdk

RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg && ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --update --sdk_root=/sdk 

RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < /sdk/packages.txt && ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager ${PACKAGES} --sdk_root=/sdk

# accept all licences
RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --licenses --sdk_root=/sdk


# ------------------------------------------------------
# --- Finishing touch
# ------------------------------------------------------

ADD scripts/get-release-notes.sh /scripts
RUN chmod +x /scripts/get-release-notes.sh


# add ANDROID_NDK_HOME to PATH
ENV PATH ${PATH}:${ANDROID_NDK_HOME}

# add ccache to PATH
ENV PATH /usr/lib/ccache:${PATH}
