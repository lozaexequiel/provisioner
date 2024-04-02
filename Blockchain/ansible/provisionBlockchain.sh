#!/bin/bash
#set -x
variables ()
{
. /vagrant_data/.env/.env
}
install_blockchain ()

{
ansible-galaxy install --role-file ${REQUIREMENTS_FILE}
ansible-playbook -v -i ${HOSTS_FILE} ${PLAYBOOK_FILE}
}

variables
install_blockchain