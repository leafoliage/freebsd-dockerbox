# FreeBSD-Dockerbox

This project is still a work in progress.

This project aims to provide usage of docker on FreeBSD by installing and running dockerd inside a linux bhyve vm called dockerbox.

## Project Structure

This repository (`freebsd-docker`) holds the core files to run a dockerbox service, including rc script and configs.

[freebsd-dockerbox-debian](https://github.com/leafoliage/freebsd-dockerbox-debian) is the repository for dockerbox's underlying disk images.

[freebsd-dockerbox-port](https://github.com/leafoliage/freebsd-dockerbox-port) holds dockerbox's port related files.

## Installation

To install from source, clone this repository and run `make install`.

```sh
# Install dockerbox script, config
make install
```

Download the dockerbox disk images.

```sh
make fetch-disk
```

Enable and start the dockerbox service.

```sh
service dockerbox enable
service dockerbox start
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

Also install tools like `grub2-bhyve` etc else you'll end up seeing error messages like `pid 2859 (bhyve), jid 0, uid 0: exited on signal 6 (no core dump - other error)` when you start dockerbox.

```sh

pkg install grub2-bhyve
pkg install e2fsprogs

```

Starting dockerbox

```sh
service dockerbox start
```

Export `DOCKER_HOST`.

```sh
export DOCKER_HOST=10.0.0.1:2375
```

Try out docker!

```sh
docker run hello-world
```

> The ip address of dockerbox is currently fixed to 10.0.0.1

Stopping dockerbox

```sh
service dockerbox stop
```

Resize docker data storage. 

```sh
dockerbox resize 1G
```

> Currently only extending storage is supported.

Log is at `/var/log/dockerbox.log`
