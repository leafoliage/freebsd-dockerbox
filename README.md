# FreeBSD-Dockerbox

This project is still a work in progress.

This project aims to provide usage of docker on FreeBSD by installing and running dockerd inside a linux bhyve vm called dockerbox.

## Installation

To install from Github, clone this repository and run `make install`.

```sh
# Install dockerbox script, config
make install
```

To install from port, go to `/sysutils/dockerbox` and run `make` and `make install`.

```sh
# Install dockerbox script, config
make
make install
```

Enable the dockerbox service and download the dockerbox disk image.

```sh
service dockerbox enable

# fetch disk image
service dockerbox fetch
```

The `make install` command automatically detects the default gateway interface for connecting to the Internet. To modify it, edit `ext_if` specified in `/usr/local/etc/dockerbox/dockerbox.conf`

```
ext_if=ue0
```

## Usage

Make sure you have `docker` installed and dockerbox's disk image downloaded.

```sh
pkg install docker

service dockerbox fetch
```

Starting dockerbox

```sh
service dockerbox start
```

Export `DOCKER_HOST`.

```sh
export DOCKER_HOST=10.0.0.3:2375
```

Try out docker!

```sh
docker run hello-world
```

> The ip address of dockerbox is currently fixed to 10.0.0.3

Stopping dockerbox

```sh
service dockerbox stop
```

Log is at `/var/log/dockerbox.log`
