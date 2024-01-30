#!/bin/bash
#set -x

header ()
{
echo "#################################################"
echo "#                                               #"
echo "#             NGINX PROVISIONER                 #"
echo "#                                               #"
echo "#################################################"
echo " "
}

variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
ls -la /vagrant_data/.env/
. /vagrant_data/.env/.env
}

install_nginx ()
{
echo "Installing Nginx"
sudo apt-get update
docker-compose up --env-file ${ENV_FILE} -d
docker ps -a
}

header
variables
install_nginx