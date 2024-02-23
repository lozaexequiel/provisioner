#!/bin/bash
#set -x

header ()
{
echo "#################################################"
echo "#                                               #"
echo "#             NEW RELIC PROVISIONER             #"
echo "#                                               #"
echo "#################################################"
echo " "
}

variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
mkdir -p /vagrant_data/.env
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
. /vagrant_data/.env/.env
}

install_new_relic ()
{
ansible-galaxy role install newrelic.newrelic_install
ansible-playbook -i /vagrant_data/.env/inventory newrelic_install.yml -e "@/vagrant_data/.env/.env"
newrelic --version
}

header
variables
install_new_relic