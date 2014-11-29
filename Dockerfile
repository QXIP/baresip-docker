# Baresip Docker

FROM phusion/baseimage:0.9.15
MAINTAINER L. Mangani <mangani@ntop.org>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN export WEB=http://www.creytiv.com/pub
RUN export ARRAY=( re-0.4.10 rem-0.4.6 baresip-0.4.11 )

# Update & Install from NTOP Package
RUN apt-get update
 
# Installing required packages
RUN sudo apt-get -y install gcc make

# Enable loopback audio
RUN sudo apt-get -y install libasound2-dev
RUN modprobe snd-aloop

RUN cd /tmp

# Install Libre
RUN wget $WEB/${ARRAY[0]}.tar.gz
RUN tar zxvf $WEB/${ARRAY[0]}.tar.gz
RUN cd ${ARRAY[0]}
RUN make && make install
RUN cd ..
RUN rm -rf ${ARRAY[0]}*

# Install Librem
RUN wget $WEB/${ARRAY[1]}.tar.gz
RUN tar zxvf $WEB/${ARRAY[1]}.tar.gz
RUN cd ${ARRAY[1]}
RUN make && make install
RUN cd ..
RUN rm -rf ${ARRAY[1]}*

# Install Baresip
RUN wget $WEB/${ARRAY[2]}.tar.gz
RUN tar zxvf $WEB/${ARRAY[2]}.tar.gz
RUN cd ${ARRAY[2]}
RUN make && make install
RUN cd ..
RUN rm -rf ${ARRAY[2]}*
 
# Updating shared libs
RUN sudo ldconfig

# Test
RUN baresip -h

# Enable Loopback
RUN sed '/^audio_player/ { s/default/hw:0,0/ }' $HOME/.baresip/config
RUN sed '/^audio_source/ { s/default/hw:0,1/ }' $HOME/.baresip/config
RUN sed '/^audio_alert/ { s/audio_alert/#audio_alert/ }' $HOME/.baresip/config  

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
