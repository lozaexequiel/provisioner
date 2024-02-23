#!/bin/bash
# remove comment if you want to enable debugging
#set -x
variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
mkdir -p /vagrant_data/.env
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
. /vagrant_data/.env/.env
}

ansible_provision ()
{
sudo apt-get update
if [ -z ${ANSIBLE_VERSION+x} ]; then
sudo apt-get install -y ansible
else
sudo apt-get install -y ansible=${ANSIBLE_VERSION}
fi
ansible --version
}

variables
ansible_provision