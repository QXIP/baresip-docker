# Baresip Docker (GIT)

#FROM phusion/baseimage:0.9.15
FROM ubuntu:14.04

MAINTAINER L. Mangani <mangani@ntop.org>

# Set correct environment variables.
ENV HOME /root
ENV TMP /tmp

# Set locale to UTF8
RUN locale-gen --no-purge en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Use baseimage-docker's init system.
# CMD ["/sbin/my_init"]

# Set software versions to install
ENV WEB http://www.creytiv.com/pub
ENV LIBRE re-0.4.10 
ENV LIBREM rem-0.4.6 
ENV BARESIP baresip-0.4.11
ENV BARESIPGIT https://github.com/alfredh/baresip.git

# Update Apt
RUN apt-get update
 
# Installing required packages
RUN sudo apt-get -y install build-essential git wget curl

# Enable audio I/O (alsa, sndfile, gst)
RUN sudo apt-get -y install libasound2-dev libasound2 libasound2-data module-init-tools libsndfile1-dev
# RUN sudo modprobe snd-dummy
# RUN sudo modprobe snd-aloop

# Install GStreamer
RUN sudo apt-get -y install gstreamer0.10-alsa gstreamer0.10-doc gstreamer0.10-ff* gstreamer0.10-tools gstreamer0.10-x gstreamer0.10-plugins-bad gstreamer0.10-plugins-base gstreamer0.10-plugins-good gstreamer0.10-plugins-ugly libgstreamer-plugins-base0.10-0 libgstreamer-plugins-base0.10-dev libgstreamer0.10-0 libgstreamer0.10-dev

# Install Libre
RUN cd $TMP && wget $WEB/$LIBRE.tar.gz && tar zxvf $LIBRE.tar.gz
RUN cd $TMP/$LIBRE && make && sudo make install
RUN cd $TMP && rm -rf $LIBRE*

# Install Librem
RUN cd $TMP && wget $WEB/$LIBREM.tar.gz && tar zxvf $LIBREM.tar.gz
RUN cd $TMP/$LIBREM && make && sudo make install
RUN cd $TMP && rm -rf $LIBREM*

  # Install Baresip
  # RUN cd $HOME && mkdir .baresip && chmod 775 .baresip
  # RUN cd $TMP && wget $WEB/$BARESIP.tar.gz && tar zxvf $BARESIP.tar.gz
  # RUN cd $TMP/$BARESIP && make && sudo make install
  # RUN cd $TMP && rm -rf $BARESIP*

# Install Baresip from GIT
RUN cd $TMP && git clone $BARESIPGIT baresip && cd $TMP/baresip && make && sudo make install
RUN cd $TMP && rm -rf baresip

# Install Configuration
RUN cd $HOME && mkdir .baresip && chmod 775 .baresip
RUN cd $TMP && git clone https://github.com/QXIP/baresip-docker.git
RUN cd $TMP/baresip-docker && cp .baresip/* $HOME/.baresip/ && cp .asoundrc $HOME/

# Updating shared libs
RUN sudo ldconfig

# Test Baresip to initialize default config and Exit
RUN baresip -t -f $HOME/.baresip
#RUN sudo baresip -h | echo

RUN ls $HOME/.baresip

# Ports for Service (SIP,RTP) and Control (HTTP,TCP)
EXPOSE 5060 5061 10000 10001 10002 10003 10004 10005 10006 10007 10008 10009 10010 10011 10012 10013 10014 10015 10016 10017 10018 10019 10020 8000 5555

# Default Baresip run command arguments
# CMD ["baresip", "-d","-f","/root/.baresip"]
CMD baresip -d -f $HOME/.baresip
CMD curl http://127.0.0.1:8000/raw/?Rsip:root:root@localhost && sleep 5 && curl http://127.0.0.1:8000/raw/?dbaresip@conference.sip2sip.info && sleep 240 && curl http://127.0.0.1:8000/raw/?bq

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
