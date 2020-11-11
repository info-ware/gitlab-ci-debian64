FROM i386/debian:jessie

RUN apt-get update && apt-get install -y build-essential
RUN apt-get install -y devscripts cmake debhelper
RUN apt-get install -y dh-systemd dh-exec pkg-config libboost-dev
RUN apt-get install -y libasound2-dev libgles2-mesa-dev 
RUN apt-get install -y gcc-multilib g++-multilib
RUN apt-get install -y libtool autoconf
RUN apt-get install -y git

# add ccache to PATH
ENV PATH /usr/lib/ccache:${PATH}
