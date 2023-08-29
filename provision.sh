#!/bin/bash
# remove comment if you want to enable debugging
#set -x
variables ()
{
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
ssh-keygen -f ${HOME}/.ssh/mykey -N ''
chown -R ${USER}:${USER} ${HOME}/.ssh
ssh-add ${HOME}/.ssh/mykey
eval "$(ssh-agent -s)"
}

install_dependencies ()
{
apt-get update
apt-get install -y ${PACKAGES}
apt-get upgrade -y
}

install_awscli ()
{
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
mkdir -p ${HOME}/.aws
cp -u ${AWS_CONFIG_FILE} ${HOME}/.aws/
cp -u ${AWS_SHARED_CREDENTIALS_FILE} ${HOME}/.aws/
./aws/install
rm -rf awscliv2.zip aws
}

clean_up ()
{
apt-get autoremove -y
apt-get clean
}

variables
disable_swap
create_ssh_key
install_dependencies
install_awscli
clean_up