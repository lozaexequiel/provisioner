#!/bin/bash
# remove comment if you want to enable debugging
#set -x
header ()
{
echo "#################################################"
echo "#                                               #"
echo "#          TERRAFORM CONFIGURATION              #"
echo "#                                               #"
echo "#################################################"
echo " "
}

variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
ls -la /vagrant_data/.env/
. /vagrant_data/.env/.env
}

terraform_provision ()
{
sudo apt-get update
sudo apt-get install -y gnupg2 curl software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
if [ -z ${TERRAFORM_VERSION+x} ]; then
sudo apt-get update && sudo apt-get install terraform
else
sudo apt-get update && sudo apt-get install terraform=${TERRAFORM_VERSION}
fi
terraform version
}

header
variables
terraform_provision