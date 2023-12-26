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
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
ls -la /vagrant_data/.env/
. /vagrant_data/.env/.env
}

disable_swap () 
{
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
swapoff -a
}

create_ssh_key ()
{
if [ ! -f ${HOME}/.ssh/mykey ]; then
mkdir -p ${HOME}/.ssh
ssh-keygen -t rsa -b 4096 -C "${USER}@${HOSTNAME}" -f ${HOME}/.ssh/mykey -q -N ""
chown -R ${USER}:${USER} ${HOME}/.ssh
ssh-add ${HOME}/.ssh/mykey
eval "$(ssh-agent -s)"
fi

}

install_dependencies ()
{
apt update
apt install -y ${PACKAGES}
apt upgrade -y
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