# Baresip Docker

FROM phusion/baseimage:0.9.15
MAINTAINER L. Mangani <mangani@ntop.org>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

WEB=http://www.creytiv.com/pub/
ARRAY=( re-0.4.10 rem-0.4.6 baresip-0.4.11 )

# Update & Install from NTOP Package
RUN apt-get update
 
# Installing required packages
sudo apt-get -y install gcc make

# Enable loopback audio
sudo apt-get -y install libasound2-dev
modprobe snd-aloop
 
for i in "${ARRAY[@]}"
do
    wget $WEB$i.tar.gz
    tar -zxvf $i.tar.gz
    cd $i/
    make
    sudo make install
    cd ..
    rm -rf $i $i.tar.gz
done
 
# Updating shared libs
sudo ldconfig

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
