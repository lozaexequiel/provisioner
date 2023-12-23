#!/bin/bash
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
cp /vagrant_data/.env/.aws/config.example ${AWS_CONFIG_FILE}
fi
if [ -z ${AWS_SHARED_CREDENTIALS_FILE+x} ]; then
AWS_SHARED_CREDENTIALS_FILE=${HOME}/.aws/credentials
touch ${AWS_SHARED_CREDENTIALS_FILE}
fi
./aws/install
rm -rf awscliv2.zip aws
echo "awscli installed"
}

clean_up ()
{
apt autoremove -y
apt clean
}

variables
install_awscli
clean_up