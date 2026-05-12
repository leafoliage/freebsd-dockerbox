# FreeBSD-Dockerbox

> [!NOTE]  
> This project is still a work in progress.

Dockerbox provides docker on FreeBSD by running dockerd inside a Linux Bhyve VM.

## Project Structure

This repository (`freebsd-docker`) holds the core files to run the dockerbox service, including rc script and configs.

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
pkg install grub2-bhyve e2fsprogs docker-cli docker-compose
```

> There is a recent patch to `grub2-bhve` and `docker-compose`; `docker` would be renamed to `docker-cli`. Please make sure the "latest" package repository is used instead of quarterly. Check with `pkg -vv`. Otherwise, `grub2-bhyve` should be built from port.

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

Setup docker context for dockerbox.

```sh
docker context create dockerbox --docker "host=ssh://dockerbox@10.0.0.1"
docker context use dockerbox
```

Altervatively, for one-shot use.

```sh
docker -H tcp://10.0.0.1:2375 ps
export DOCKER_HOST=tcp://10.0.0.1:2375; docker ps
```

Docker run.

```sh
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

Access dockerbox console with dockerbox built in `console` command or `ssh`.

```sh
dockerbox console
ssh dockerbox@10.0.0.1
```

Log is at `/var/log/dockerbox.log`

### Advanced Usages

Refer to the [wiki](https://github.com/leafoliage/freebsd-dockerbox/wiki) for advanced usages:

- [Port publishing and mapping](https://github.com/leafoliage/freebsd-dockerbox/wiki/Port-publishing-and-mapping)
- [Bind mounts](https://github.com/leafoliage/freebsd-dockerbox/wiki/Bind-mounts)
- [Docker volumes](https://github.com/leafoliage/freebsd-dockerbox/wiki/Docker-volumes)
- [Docker compose](https://github.com/leafoliage/freebsd-dockerbox/wiki/Docker-compose)

### Upgrade dockerbox root disk

Make sure new version of `sbin/dockerbox` is installed, then upgrade root disk. It would prompt for permission to replace old disk, enter 'y' to proceed.

```
dockerbox fetch
```

## Configs

- Default config

```
# /usr/local/etc/dockerbox/dockerbox.conf
cpu=1
memory=1024M
ext_if=auto
nat_ip=10.0.0.254
nat_mask=24
console=yes
```

Refer to [wiki/Configuration](https://github.com/leafoliage/freebsd-dockerbox/wiki/Configuration) for details.

## Dockerbox Structure

Dockerbox runs on a root disk and a docker data disk. The docker data disk is mounted at `/var/lib/docker`, and the rest of they system is installed on the root disk. The separate disk design is to simplify disk space management and resizing.
