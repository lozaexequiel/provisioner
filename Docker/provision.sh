#!/bin/bash
# remove comment if you want to enable debugging
#set -x
variables ()
{
. /vagrant_data/.env/.env
}

docker_provision ()
{
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL [1](https://download.docker.com/linux/debian/gpg) | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] [2](https://download.docker.com/linux/debian) $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce
sudo systemctl status docker
# add docker privileges to user and configure docker
usermod -G docker ${USER}
}

variables
docker_provision