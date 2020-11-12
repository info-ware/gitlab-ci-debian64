FROM debian:buster

RUN apt-get update 
RUN apt-get install -y build-essential devscripts cmake
RUN apt-get install -y gcc g++  
RUN apt-get install -y debhelper dh-systemd dh-exec pkg-config 
RUN apt-get install -y libtool autoconf
RUN apt-get install -y git
RUN apt-get install -y libasound2-dev libgles2-mesa-dev libboost-all-dev 

RUN mkdir -m 0750 /root/.android
RUN apt-get install -y --no-install-recommends \
      bzip2 \
      curl \
      git-core \
      html2text \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32z1 \
      unzip \
      openssh-client \
      sshpass \
      lftp \
      doxygen \
      doxygen-latex \
      graphviz \
      wget \
      ccache \
      joe \
      maven \
      default-jdk \
      binutils-i686-linux-gnu
            
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Correction needed for java certificates
RUN dpkg --purge --force-depends ca-certificates-java
RUN apt-get install ca-certificates-j

# add ccache to PATH
ENV PATH /usr/lib/ccache:${PATH}
