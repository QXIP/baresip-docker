baresip-docker
==============

<img src="https://raw.githubusercontent.com/baresip/baresip/master/share/logo.png" width=300>

Baresip docker container for headless Call Testing

## Features:

* Baresip v0.6.6
  - *HTTPD Module*
  - *CONS Module*
  - *GST Module*
  - *ALSA Loopback (snd-aloop)*

## Install:
```
docker pull qxip/baresip-docker
docker run -name baresip --rm -ti --device=/dev/snd:/dev/snd qxip/baresip-docker
```

## Usage

### CMD
##### Command Line Interface
Register two SIP accounts to create a route loop initiating and terminating at our agent
```
/uanew sip:100@sip.host.com;auth_pass=mypassword;;answermode=auto
/uanew sip:200@sip.host.com;auth_pass=mypassword;;answermode=auto
```
Once registered, Dial your loop from 100 to 200
```
d 200
b
```
Check out the call statistics for both legs
```
sip:100-0x17efe40@172.17.0.2:59989: Call with sip:200@10.0.0.1 terminated (duration: 40 secs)

audio           Transmit:     Receive:
packets:           1798         1782
avg. bitrate:      63.8         63.6  (kbit/s)
errors:               0            0
pkt.report:        1648         1632
lost:                 0            0
jitter:             0.0          0.1  (ms)

sip:200-0x17efe40@172.17.0.2:59989: Call with sip:100@10.0.0.1 terminated (duration: 40 secs)

audio           Transmit:     Receive:
packets:           2094         1793
avg. bitrate:      63.8         60.6  (kbit/s)
errors:               0            0
pkt.report:        1846         1641
lost:                 0            0
jitter:             0.0          0.0  (ms)
```

-------------

### HTTP
##### Webserver User-Interface (UI) using HTTP Socket
This module implements an HTTPD server for connecting to Baresip using HTTP Protocol. 
You can use programs like CURL to connect to the command-line interface.

Register two SIP accounts to create a route loop initiating and terminating at our agent
```
# curl http://127.0.0.1:8000/?/uanew%20sip%3A100%40sip.host.com%3Bauth_pass%3Dmypassword%3Banswermode=auto
# curl http://127.0.0.1:8000/?/uanew%20sip%3A200%40sip.host.com%3Bauth_pass%3Dmypassword%3Banswermode=auto
```
Once registered, Dial your loop from 100 to 200
```
# curl http://127.0.0.1:8000/?/d%20200
# curl http://127.0.0.1:8000/?/b
```
Check out the call statistics for both legs


-------------

### CONS
##### Console User-Interface (UI) using UDP/TCP sockets
 
This module implements a simple console for connecting to Baresip via UDP or TCP-based sockets. 
You can use programs like telnet or netcat to connect to the command-line interface.
 
Example, with the cons-module listening on default port 5555:
 
```
# netcat -u 127.0.0.1 5555
uanew sip:100@sip.host.com;auth_pass=mypassword;;answermode=auto
uanew sip:200@sip.host.com;auth_pass=mypassword;;answermode=auto
d 200
b
```

-------------

## Credits
Baresip is Copyright (c) 2010 - 2020 Creytiv.com Distributed under BSD license
