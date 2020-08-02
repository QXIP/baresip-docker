# Baresip Docker Sources (GIT)
FROM ubuntu:16.04

MAINTAINER L. Mangani <lorenzo.mangani@gmail.com>

# Set correct environment variables.
ENV DEBIAN_FRONTEND noninteractive 
ENV HOME /root
ENV TMP /tmp

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Set locale to UTF8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Set software versions to install
ENV WEB http://www.creytiv.com/pub
ENV LIBRE 0.6.1
ENV LIBREGIT https://github.com/creytiv/re/releases/download
ENV LIBREM 0.6.0
ENV LIBREMGIT https://github.com/creytiv/rem/releases/download
ENV BARESIP 0.6.6
ENV BARESIPGIT https://github.com/baresip/baresip/archive

# Update Apt
RUN apt-get update \
 
# Installing required packages
&& apt-get -y install build-essential git wget curl \

# Enable audio I/O (alsa, sndfile, gst)
&& apt-get -y install libasound2-dev libasound2 libasound2-data module-init-tools libsndfile1-dev \

# Install GStreamer
&& apt-get install -y gstreamer-1.0* && apt-get install -y gstreamer1.0*

# Install Libre
RUN cd $TMP && wget $LIBREGIT/v$LIBRE/re-$LIBRE.tar.gz && tar zxvf re-$LIBRE.tar.gz && cd re-$LIBRE && make STATIC=yes && make install

# Install Librem
RUN cd $TMP && wget $LIBREMGIT/v$LIBREM/rem-$LIBREM.tar.gz && tar zxvf rem-$LIBREM.tar.gz && cd rem-$LIBREM && make STATIC=yes && make install

# Install Librem
RUN cd $TMP && wget $BARESIPGIT/v$BARESIP.tar.gz && tar zxvf v$BARESIP.tar.gz && cd baresip-$BARESIP && make STATIC=yes && make install

# Updating shared libs
RUN ldconfig

# Baresip Docker Slim (GIT)
FROM ubuntu:16.04
MAINTAINER L. Mangani <lorenzo.mangani@gmail.com>
WORKDIR /
ENV HOME /root

COPY --from=0 /usr/local/bin/baresip /usr/local/bin/baresip
COPY --from=0 /usr/local/lib/libre.so /usr/local/lib/libre.so
COPY --from=0 /usr/local/lib/libre.a /usr/local/lib/libre.a
COPY --from=0 /usr/local/lib/librem.so /usr/local/lib/librem.so
COPY --from=0 /usr/local/lib/librem.a /usr/local/lib/librem.a
COPY --from=0 /usr/local/lib/baresip /usr/local/lib/baresip
COPY --from=0 /usr/local/share/baresip /usr/local/share/baresip

COPY --from=0 /usr/lib/x86_64-linux-gnu/gstreamer-1.0 /usr/lib/x86_64-linux-gnu/gstreamer-1.0
COPY --from=0 /usr/lib/x86_64-linux-gnu/libgst* /usr/lib/x86_64-linux-gnu/
COPY ./testcall.mp3 /testcall.mp3

COPY /.baresip $HOME/.baresip
COPY /.asoundrc $HOME/.asoundrc
COPY ./dummy.sh $HOME/dummy.sh

RUN ldconfig && apt-get update && apt-get --no-install-recommends -y install libasound2-dev libasound2 libasound2-data libsndfile1-dev gstreamer0.10-alsa alsa-oss alsa-utils module-init-tools libgstreamer1.0-dev  \
 && ldconfig \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && $HOME/dummy.sh

# Test Baresip to initialize default config and Exit
#RUN /usr/local/bin/baresip -t -f /.baresip

# Ports for Service (SIP,RTP) and Control (HTTP,TCP)
EXPOSE 5060 5061 10000-10020 8000 5555

# Default Baresip run command arguments
CMD ["baresip", "-f","/root/.baresip"]
