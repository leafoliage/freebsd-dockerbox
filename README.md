# FreeBSD-Dockerbox

This project is still a work in progress.

This project aims to provide usage of docker on FreeBSD by installing and running dockerd inside a linux bhyve vm called dockerbox.

## Installation

Use the following commands to install dockerbox.

```sh
wget https://github.com/leafoliage/freebsd-dockerbox/releases/download/disk-0.1.0/dockerbox-img.tar.gz
mkdir -p /usr/local/share/dockerbox
tar -xf -C /usr/local/share/dockerbox dockerbox-img.tar.gz

git clone https://github.com/leafoliage/freebsd-dockerbox.git
mkdir -p /usr/local/etc/dockerbox
cp freebsd-dockerbox/etc/dockerbox.conf /usr/local/etc/dockerbox
cp freebsd-dockerbox/sbin/dockerbox /usr/local/sbin
```

## Usage

Starting dockerbox

```sh
sudo dockerbox start
```

Stopping dockerbox

```sh
sudo dockerbox stop
```
