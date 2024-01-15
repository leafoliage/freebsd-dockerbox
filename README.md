# FreeBSD-Dockerbox

This project is still a work in progress.

This project aims to provide usage of docker on FreeBSD by installing and running dockerd inside a linux bhyve vm called dockerbox.

## Installation

Use the following commands to install dockerbox.

Install dockerbox disk image.

```sh
wget https://github.com/leafoliage/freebsd-dockerbox/releases/download/disk-0.1.0/dockerbox-img.tar.gz
mkdir -p /usr/local/share/dockerbox
tar -xf dockerbox-img.tar.gz -C /usr/local/share/dockerbox
```

Install dockerbox script and config.

```sh
git clone https://github.com/leafoliage/freebsd-dockerbox.git
mkdir -p /usr/local/etc/dockerbox
cp freebsd-dockerbox/etc/dockerbox.conf /usr/local/etc/dockerbox
cp freebsd-dockerbox/sbin/dockerbox /usr/local/sbin
cp freebsd-dockerbox/rc.d/dockerbox /usr/local/etc/rc.d
```

Install docker client.

```sh
pkg install docker
```

Modify the external interface specified in `/usr/local/etc/dockerbox/dockerbox.conf` for connecting to the Internet

```
ext_if="ue0"
```

## Usage

Starting dockerbox

```sh
sudo dockerbox start
```

Run docker with dockerbox

```sh
docker -H 10.0.0.3 run hello-world
```

> The ip address of dockerbox is currently fixed to 10.0.0.3

Stopping dockerbox

```sh
sudo dockerbox stop
```

Running dockerbox as service

```sh
sudo service dockerbox start
```

Log is at `/var/log/dockerbox.log`
