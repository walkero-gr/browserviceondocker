[![Build Status](https://drone-gh.intercube.gr/api/badges/walkero-gr/browservice/status.svg)](https://drone-gh.intercube.gr/walkero-gr/browservice)
[![Docker Pulls](https://img.shields.io/docker/pulls/walkero/browservice?color=brightgreen)](https://hub.docker.com/r/walkero/browservice)

# browserviceondocker
This is a docker image for [browservice](https://github.com/ttalvitie/browservice/)

## How to create a docker container

To create a container based on one of these images, run in the terminal:

```bash
docker run -it --rm --name browservice-amd64 -p 8080:8080 walkero/browservice:latest-amd64
```

If you want to use it with **docker-compose**, you can create a *docker-compose.yml* file, with the following content:

```yaml
version: '3'

services:
  browservice:
    image: 'walkero/browservice:latest-amd64'
    ports:
    - 8080:8080
```

And then you can access browservice in your browser by going to
http://localhost:8080

