#!/bin/bash
#set -x
header ()
{
echo "#################################################"
echo "#                                               #"
echo "#                   PROVISIONER                 #"
echo "#                                               #"
echo "#################################################"
echo ""
}

variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
mkdir -p /vagrant_data/.env
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
. /vagrant_data/.env/.env
}

disable_swap ()
{
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
swapoff -a
}

install_dependencies ()
{
apt update
apt upgrade -y
apt install -y ${PACKAGES}
}

clean_up ()
{
apt autoremove -y
apt clean
}

header
variables
disable_swap
create_ssh_key
install_dependencies
clean_up