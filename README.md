# FreeBSD-Dockerbox

This project is still a work in progress.

This project aims to provide usage of docker on FreeBSD by installing and running dockerd inside a linux bhyve vm called dockerbox.

## Project Structure

This repository (`freebsd-docker`) holds the core files to run a dockerbox service, including rc script and configs.

[freebsd-dockerbox-debian](https://github.com/leafoliage/freebsd-dockerbox-debian) is the repository for dockerbox's underlying disk images.

[freebsd-dockerbox-port](https://github.com/leafoliage/freebsd-dockerbox-port) holds dockerbox's port related files.

## Quickstart

### Install from source

To install from source, clone this repository and run `make install`.

```sh
git clone https://github.com/leafoliage/freebsd-dockerbox.git
```

```sh
make install
```

Download the dockerbox disk image.

```sh
make fetch-disk
```

Install helper packages.

```sh
pkg install grub2-bhyve e2fsprogs docker
```

> There is a recent patch for `grub2-bhve` essential to dockerbox. Please make sure the "latest" package repository is used instead of quarterly. Check with `pkg -vv`. Otherwise, `grub2-bhyve` should be built from port.

Enable and start the dockerbox service.

```sh
sysrc dockerbox_enable=YES
service dockerbox enable
service dockerbox start
```

Run docker command with remote docker specified.

```sh
docker -H 10.0.0.1:2375 run hello-world
```

### Install from port

See [freebsd-dockerbox-port Quickstart](https://github.com/leafoliage/freebsd-dockerbox-port#quickstart).

## Usage

Starting dockerbox.

```sh
service dockerbox start
```

Export `DOCKER_HOST` and run docker commands.

```sh
export DOCKER_HOST=10.0.0.1:2375
docker run hello-world
```

Stopping dockerbox.

```sh
service dockerbox stop
```

Resize docker data storage. 

```sh
dockerbox resize 1G
```

> Currently only extending storage is supported.

Log is at `/var/log/dockerbox.log`

## Configs

```
# /usr/local/etc/dockerbox/dockerbox.conf
cpu: cpu cores for dockerbox
memory: RAM for dockerbox
ext_if: the external network interface
nat_ip: the IP address for NAT gateway
nat_mask: netmask for NAT
console: start dockerbox with a nmdm device or not
```

> The `make install` command automatically detects the default gateway interface for connecting to the Internet.

> The ip address of dockerbox is currently fixed to 10.0.0.1

## Dockerbox Structure

Dockerbox runs on a root disk and a docker data disk. The docker data disk is mounted at `/var/lib/docker`, and the rest of they system is installed on the root disk. The separate disk design is to simplify disk space management and resizing.
