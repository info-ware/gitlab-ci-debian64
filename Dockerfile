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

export ANDROID_NDK_VERSION="r18b"
export ANDROID_NDK_HOME=/opt/android-ndk

# download
mkdir /opt/android-ndk-tmp
cd /opt/android-ndk-tmp
wget  https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION
# uncompress
unzip android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
# move to its final location
mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME}
# remove temp dir
cd ${ANDROID_NDK_HOME}
rm -rf /opt/android-ndk-tmp


# add ccache to PATH
#ENV PATH /usr/lib/ccache:${PATH}
