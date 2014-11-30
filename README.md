baresip-docker
==============

Baresip docker container

## Features:

* Baresip v0.4.11
  - *HTTPD Module*
  - *CONS Module*
  - *ALSA Loopback (snd-aloop)*

## Install:
```
docker pull qxip/baresip-docker
docker run -name baresip -t -i qxip/baresip-docker
```

## Usage:

##### HTTPD: Webserver User-Interface (UI) using HTTP Socket
This module implements an HTTPD server for connecting to Baresip using HTTP Protocol. 
You can use programs like CURL to connect to the command-line interface.
```
# curl http://127.0.0.1:8000/?l

<html>
<head>
<title>Baresip v0.4.11</title>
</head>
<body>
<pre>

--- List of active calls (0): ---

</pre>
</body>
</html>

```

##### CONS: Console User-Interface (UI) using UDP/TCP sockets
 
This module implements a simple console for connecting to Baresip via UDP or TCP-based sockets. 
You can use programs like telnet or netcat to connect to the command-line interface.
 
Example, with the cons-module listening on default port 5555:
 
```
# netcat -u 127.0.0.1 5555
l

--- List of active calls (0): ---

```
