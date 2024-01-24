# FreeBSD-Dockerbox

This project is still a work in progress.

This project aims to provide usage of docker on FreeBSD by installing and running dockerd inside a linux bhyve vm called dockerbox.

## Installation

Use the following commands to install dockerbox.

Install required packages such as grub-bhyve and docker client.

```sh
pkg install grub2-bhyve
pkg install docker
pkg install git
```

Install dockerbox disk image.

```sh
sudo make image
```

Install dockerbox script and config.

```sh
sudo make install
```

The `make install` command automatically detects the default gateway interface for connecting to the Internet. To modify it, edit `ext_if` specified in `/usr/local/etc/dockerbox/dockerbox.conf`

```
ext_if=ue0
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

Enable dockerbox service

```sh
sudo sysrc dockerbox_enable=YES
```

Running dockerbox as service

```sh
sudo service dockerbox start
```

Log is at `/var/log/dockerbox.log`
