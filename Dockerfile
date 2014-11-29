# Baresip Docker

FROM phusion/baseimage:0.9.15
MAINTAINER L. Mangani <mangani@ntop.org>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN export WEB=http://www.creytiv.com/pub
RUN export LIBRE=re-0.4.10 
RUN export LIBREM=rem-0.4.6 
RUN export BARESIP=baresip-0.4.11

# Update & Install from NTOP Package
RUN apt-get update
 
# Installing required packages
RUN sudo apt-get -y install gcc make

# Enable loopback audio
RUN sudo apt-get -y install libasound2-dev
RUN modprobe snd-aloop

RUN cd /tmp

# Install Libre
RUN wget $WEB/$LIBRE.tar.gz
RUN tar zxvf $WEB/$LIBRE.tar.gz
RUN cd $LIBRE
RUN make && make install
RUN cd ..
RUN rm -rf $LIBRE*

# Install Librem
RUN wget $WEB/$LIBREM.tar.gz
RUN tar zxvf $WEB/$LIBREM.tar.gz
RUN cd $LIBREM
RUN make && make install
RUN cd ..
RUN rm -rf $LIBREM*

# Install Baresip
RUN wget $WEB/$BARESIP.tar.gz
RUN tar zxvf $WEB/$BARESIP.tar.gz
RUN cd $BARESIP
RUN make && make install
RUN cd ..
RUN rm -rf $BARESIP*
 
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

# Re-Test
RUN baresip -h
