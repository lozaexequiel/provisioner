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
mkdir -p /vagrant_data/.env
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
. /vagrant_data/.env/.env
}

terraform_provision ()
{
apt update
apt install -y gnupg2 curl software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt update
apt install terraform -y
terraform version
}

terraform_apply ()
{
if [ ! -z ${TF_VARS} ]; then
grep 'TF_VARS' .env.example >> /vagrant_data/.env/.env
fi
cd /vagrant_data/
terraform plan -var-file ${TF_VARS} -out=${TF_PLAN_PATH}
terraform apply ${TF_PLAN_PATH}
}

header
variables
terraform_provision
terraform_apply