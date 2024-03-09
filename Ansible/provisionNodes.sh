#!/bin/bash
#set -x
variables ()
{
if [ ! -d /vagrant_data/.env ]; then
mkdir -p /vagrant_data/.env
fi
if [ ! -f /vagrant_data/.env/.env ]; then
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
. /vagrant_data/.env/.env
}

ansible_provision ()
{
apt update
if [ -z ${ANSIBLE_VERSION+x} ]; then
apt install -y ansible
else
apt install -y ansible=${ANSIBLE_VERSION}
fi
ansible --version
}

variables
ansible_provision