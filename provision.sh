#!/bin/bash
# remove comment if you want to enable debugging
#set -x
variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
ls -la /vagrant_data/
. /vagrant_data/.env/.env
}

disable_swap () 
{
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
swapoff -a
}

create_ssh_key ()
{
[[ ! -f ${HOME}/.ssh/mykey ]]
mkdir -p ${HOME}/.ssh
ssh-keygen -f ${HOME}/.ssh/mykey -N ""
chown -R ${USER}:${USER} ${HOME}/.ssh
ssh-add ${HOME}/.ssh/mykey
eval "$(ssh-agent -s)"
}

install_dependencies ()
{
sudo apt update
sudo apt install -y ${PACKAGES}
sudo apt upgrade -y
}

clean_up ()
{
sudo apt autoremove -y
sudo apt clean
}

variables
disable_swap
create_ssh_key
install_dependencies
clean_up