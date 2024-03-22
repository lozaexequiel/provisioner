#!/bin/bash
#set -x
variables ()
{
if [ ! -d /vagrant_data/.env ]; then
echo "WARNING! The .env directory does not exist or is not detected"
exit 1
fi
if [ ! -f /vagrant_data/.env/.env ]; then
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
. /vagrant_data/.env/.env
}

ansible_test ()
{
cd ${ANSIBLE_DIR}
sudo ANSIBLE_HOST_KEY_CHECKING=False ansible all -m ping -i ${INVENTORY_FILE} -u ${USER} --private-key=${PRIVATE_KEY_FILE}
}

variables
ansible_test