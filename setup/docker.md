# Docker
Docker is a containerization and virtualization platform I use for deployment of several projects. It makes up an important part of my development framework especially for being able to test server-side functionality without having to deploy the app to a cloud resource.
Docker requires KVM and Qemu for isntallation, see setup/kvm.md for details. Further documentation can be found at (Docker Linux Install)[https://docs.docker.com/desktop/install/linux-install/] page.

## Install via the official Apt repository
This installation of Docker has a few other prerequisites that should already be installed.

### Check for Prerequisites
Let's make sure they are installed and up to date.
```
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
```

### Add Docker GPG Key and Repository
We need to add the Docker official GPG public key and their apt repository.
```shell
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/usr/share/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Install Docker with Apt
Now we can update the apt repositories and install Docker with it's recommended tools.
```
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
Previously, I had also installed `docker-compose` but it no longer appears necessary according to Docker's instructions. If I run into any issues I should probably reinstall this. I'll try to update here if I do.

## Fix Docker Permissions
Docker requires root access to run. This is a security risk and we need to fix it. The recommended way to do this is to add your user to the docker group. This will allow your user to run docker commands without sudo.
```shell
sudo usermod -aG docker ${USER}
```
You will then need to log in again or run the command below to gain the group permissions.
```shell
newgrp docker
```

## Test Docker Installation
We can quickly test to make sure docker is working using the Docker hello-world container.
```
docker run hello-world
```
If the permissions are not fixed as above this will need to be run with `sudo`.

## Docker Desktop
Docker recommends installing the Docker Desktop as well. I have found I don't really need it and I haven't found any good reason to use it in the past. I'll be skipping the installation for now.

I'm leaving these instructions below in case I change my mind.

Docker Desktop is a GUI for managing Docker containers and VMs.
```shell
sudo apt install gnome-terminal
sudo apt remove docker-desktop
rm -r $HOME/.docker/desktop
sudo rm /usr/local/bin/com.docker.cli
sudo apt purge docker-desktop
```
Download the latest version of Docker Desktop from the [Docker Desktop](https://www.docker.com/products/docker-desktop) page. The latest version as of this writing is 4.1.1.

```shell
sudo apt-get update
sudo apt-get install ./docker-desktop-<version>-<arch>.deb
```
