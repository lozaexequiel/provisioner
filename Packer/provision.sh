#!/bin/bash
# remove comment if you want to enable debugging
#set -x
variables ()
{
. /vagrant_data/.env/.env
}

packer_provision ()
{
sudo apt update
sudo apt install -y gnupg2 curl software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install -y packer
packer plugins install github.com/hashicorp/amazon
packer plugins install github.com/hashicorp/ansiblepacker plugins install github.com/hashicorp/ansible
#cloudflare API
#sudo apt install libwww-perl -y

variables
packer_provision
