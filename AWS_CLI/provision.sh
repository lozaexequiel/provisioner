#!/bin/bash
# remove comment if you want to enable debugging
#set -x
variables ()
{
. /vagrant_data/.env/.env
}
install_awscli ()
{
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
mkdir -p ${HOME}/.aws
if [ -z ${AWS_CONFIG_FILE+x} ]; then
AWS_CONFIG_FILE=${HOME}/.aws/config
touch ${AWS_CONFIG_FILE}
fi
if [ -z ${AWS_SHARED_CREDENTIALS_FILE+x} ]; then
AWS_SHARED_CREDENTIALS_FILE=${HOME}/.aws/credentials
touch ${AWS_SHARED_CREDENTIALS_FILE}
fi

./aws/install
rm -rf awscliv2.zip aws
echo "awscli installed"
}

disable_swap () 
{
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
swapoff -a
}

clean_up ()
{
apt-get autoremove -y
apt-get clean
}

variables
install_awscli
clean_up