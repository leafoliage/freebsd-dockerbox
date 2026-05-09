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
pkg install grub2-bhyve e2fsprogs docker docker-compose
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

Access dockerbox console with dockerbox built in `console` command or `ssh`.

```sh
dockerbox console
ssh dockerbox@10.0.0.1
```

> Currently only extending storage is supported.

Log is at `/var/log/dockerbox.log`

### Publishing and exposing ports

Dockerbox currently doesn't support port forwarding from host to dockerbox, all docker exposed ports should be accessed at dockerbox's IP address.

```sh
docker -H 10.0.0.1:2375 run -p 8080:80 --name nginx -d nginx
fetch http://10.0.0.1:8080
```

### Bind mounts

Dockerbox doesn't support bind mounting from host into dockerbox's docker container.

To make host files/directories accessible to containers, use `docker cp`.

```sh
docker -H 10.0.0.1:2375 cp -r /path/to/file nginx:/usr/share/nginx/html/
```

Note that `docker cp` is incompatible with FreeBSD directories, so manually tarring the directory is requried.

```sh
tar -c -f - /path/to/dir | docker -H 10.0.0.1:2375 cp - nginx:/usr/share/nginx/html/
```

Here is a helper script for copying directory.

```sh
#!/bin/sh
[ -z "$2" ] && echo "Usage: $0 SRC_PATH CONTAINER_DST_PATH" && exit 1
tar -c -f - "$1" | docker -H 10.0.0.1:2375 cp - "$2"
```

```sh
./dockerbox-cp /path/to/dir nginx:/usr/share/nginx/html/
```

Alternatively, `scp` files/directories into dockerbox to be bind-mount.

### Docker volumes

Docker volumes are managed by docker in dockerbox, so they can be normally used.

### Docker compose

> [!WARNING]
> Docker compose compatibility is still under testing.

Install docker compose.

> [!IMPORTANT]
> There is a recent update to `docker-compose` port.
> Please make sure the "**latest**" package repository is used instead of quarterly. Check with `pkg -vv`.

```
pkg install docker-compose
```

Use [awesome-compose/nextcloud-redis-mariadb](https://github.com/docker/awesome-compose/blob/master/nextcloud-redis-mariadb/compose.yaml) as example. Start this docker compose.

```
docker-compose -H tcp://10.0.0.1:2375 up -d
```

Port forward with `socat` if you want to access it on host.

```
socat TCP4-LISTEN:8080,fork,reuseaddr TCP4:10.0.0.1:80
```

Nextcloud should be accessible at `localhost:8080`.

If building docker container is involved during `docker-compose up`, it is recommended to first export `DOCKER_HOST=tcp://10.0.0.1:2375`.

```
export DOCKER_HOST=tcp://10.0.0.1:2375
docker-compose up -d
```

### Upgrade dockerbox root disk

Make sure new version of `sbin/dockerbox` is installed, then upgrade root disk. It would prompt for permission to replace old disk, enter 'y' to proceed.

```
dockerbox fetch
```

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

> The ip address of dockerbox is currently fixed to 10.0.0.1

## Dockerbox Structure

Dockerbox runs on a root disk and a docker data disk. The docker data disk is mounted at `/var/lib/docker`, and the rest of they system is installed on the root disk. The separate disk design is to simplify disk space management and resizing.
