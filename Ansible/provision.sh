#!/bin/bash
#set -x
header ()
{
echo "#################################################"
echo "#                                               #"
echo "#              ANSIBLE PROVISIONER              #"
echo "#                                               #"
echo "#################################################"
echo ""
}
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

create_ssh_key ()
{
if [ ! -f ${HOME}/.ssh/mykey ]; then
mkdir -p ${HOME}/.ssh
ssh-keygen -t rsa -b 4096 -C "${USER}@${HOSTNAME}" -f ${HOME}/.ssh/mykey -q -N ""
chown -R ${USER}:${USER} ${HOME}/.ssh
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/mykey
fi
}

ansible_provision ()
{
if [[ ! $(hostname) =~ (master|node) ]]; then
  echo "Error: The hostname must contain 'master' or 'node' to run this script"
  exit 1
fi
apt update
if [ -z ${ANSIBLE_VERSION+x} ]; then
apt install -y ansible
else
apt install -y ansible=${ANSIBLE_VERSION}
fi
ansible --version
}

ansible_configuration ()
{
if [ ! -d ${ANSIBLE_DIR} ]; then
mkdir -p ${ANSIBLE_DIR}
fi
hostname=$(hostname)
case "$hostname" in
  *master*)
    	echo "Configuring ansible master with hostname: $hostname"
	cp ${HOME}/.ssh/mykey ${ANSIBLE_PATH}/.ssh/mykey
	cp ${HOME}/.ssh/mykey.pub ${ANSIBLE_PATH}/.ssh/mykey.pub
	cp ${HOME}/.ssh/authorized_keys ${ANSIBLE_PATH}/.ssh/authorized_keys
	chmod 700 ${ANSIBLE_PATH}/.ssh
	chmod 600 ${ANSIBLE_PATH}/.ssh/authorized_keys
	chown -R ${USER}:${USER} ${ANSIBLE_PATH}/.ssh
    ;;
  *node*)
	echo "Configuring ansible node with hostname: $hostname"
	cat ${ANSIBLE_PATH}/.ssh/mykey.pub >> ${HOME}/.ssh/authorized_keys
	chmod 700 ${HOME}/.ssh
	chmod 600 ${HOME}/.ssh/authorized_keys
	chown -R ${USER}:${USER} ${HOME}/.ssh
    ;;
  *)
    echo "Error: The hostname must contain 'master' or 'node' to run this script"
    exit 1
    ;;
esac
}
header
variables
create_ssh_key
ansible_provision
ansible_configuration