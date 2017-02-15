# Baresip Docker (GIT)

FROM phusion/baseimage:latest
#FROM ubuntu:14.04

MAINTAINER L. Mangani <lorenzo.mangani@gmail.com>

# Set correct environment variables.
ENV DEBIAN_FRONTEND noninteractive 
ENV HOME /root
ENV TMP /tmp

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Set locale to UTF8
RUN locale-gen --no-purge en_US.UTF-8 && update-locale LANG=en_US.UTF-8 && dpkg-reconfigure locales
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Use baseimage-docker's init system.
# CMD ["/sbin/my_init"]

# Set software versions to install
ENV WEB http://www.creytiv.com/pub
ENV LIBRE re-0.4.17 
ENV LIBREM rem-0.4.7 
ENV BARESIP baresip-0.4.20
ENV BARESIPGIT https://github.com/alfredh/baresip.git

# Update Apt
RUN apt-get update \
 
# Installing required packages
&& apt-get -y install build-essential git wget curl \

# Enable audio I/O (alsa, sndfile, gst)
&& apt-get -y install libasound2-dev libasound2 libasound2-data module-init-tools libsndfile1-dev gstreamer0.10-alsa \
# RUN sudo modprobe snd-dummy
# RUN sudo modprobe snd-aloop

# Install GStreamer
&& apt-get -y install gstreamer0.10-alsa gstreamer0.10-tools gstreamer0.10-x gstreamer0.10-plugins-base gstreamer0.10-plugins-good libgstreamer-plugins-base0.10-0 libgstreamer-plugins-base0.10-dev libgstreamer0.10-0 libgstreamer0.10-dev

# Install Libre
RUN cd $TMP && wget $WEB/$LIBRE.tar.gz && tarzxvf $LIBRE.tar.gz && cd $LIBRE && make && make install 

# Install Librem
RUN cd $TMP && wget $WEB/$LIBREM.tar.gz && tarzxvf $LIBREM.tar.gz && cd $LIBREM && make && make install 

  # Install Baresip
  # RUN cd $HOME && mkdir .baresip && chmod 775 .baresip
  # RUN cd $TMP && wget $WEB/$BARESIP.tar.gz && tar zxvf $BARESIP.tar.gz
  # RUN cd $TMP/$BARESIP && make && sudo make install
  # RUN cd $TMP && rm -rf $BARESIP*

# Install Baresip from GIT
RUN cd $TMP && git clone $BARESIPGIT baresip && cd baresip && make && make install 

# Install Configuration from self
RUN cd $HOME && mkdir baresip && chmod 775 baresip \
&& cd $TMP && git clone https://github.com/QXIP/baresip-docker.git \
&& cp -R $TMP/baresip-docker/.baresip $HOME/ \
&& cp $TMP/baresip-docker/.asoundrc $HOME/ \
&& rm -rf $TMP/baresip-docker 

# Updating shared libs
RUN ldconfig

# Test Baresip to initialize default config and Exit
RUN baresip -t -f $HOME/.baresip
#RUN sudo baresip -h | echo
#RUN ls $HOME/.baresip

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Ports for Service (SIP,RTP) and Control (HTTP,TCP)
EXPOSE 5060 5061 10000-10020 8000 5555

# Default Baresip run command arguments
CMD ["baresip", "-d","-f","/root/.baresip"]
#CMD baresip -d -f $HOME/.baresip && sleep 2 && curl http://127.0.0.1:8000/raw/?Rsip:root:root@127.0.0.1 && sleep 5 && curl http://127.0.0.1:8000/raw/?dbaresip@conference.sip2sip.info && sleep 60 && curl http://127.0.0.1:8000/raw/?bq
