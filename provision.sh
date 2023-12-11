#!/bin/bash
# remove comment if you want to enable debugging
#set -x
variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
sudo cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
. /vagrant_data/.env/.env
}

disable_swap () 
{
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
}

create_ssh_key ()
{
[[ ! -f ${HOME}/.ssh/mykey ]]
sudo mkdir -p ${HOME}/.ssh
no | sudo ssh-keygen -f ${HOME}/.ssh/mykey -N ""
sudo chown -R ${USER}:${USER} ${HOME}/.ssh
sudo ssh-add ${HOME}/.ssh/mykey
sudo eval "$(ssh-agent -s)"
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