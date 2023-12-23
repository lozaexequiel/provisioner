#!/bin/bash
# remove comment if you want to enable debugging
#set -x
variables ()
{
. /vagrant_data/.env/.env
}

terraform_provision ()
{
sudo apt-get update
sudo apt-get install -y gnupg2 curl software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
#if variable TERRAFORM_VERSION is not set, install the latest version of terraform
#if variable TERRAFORM_VERSION is set, install the version of terraform set in the variable
if [ -z ${TERRAFORM_VERSION+x} ]; then
sudo apt-get update && sudo apt-get install terraform
else
sudo apt-get update && sudo apt-get install terraform=${TERRAFORM_VERSION}
fi
terraform version
}

variables
terraform_provision