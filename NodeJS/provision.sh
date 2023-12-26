#!/bin/bash
#set -x

header ()
{
echo "#################################################"
echo "#                                               #"
echo "#                NODEJS PROVISIONER             #"
echo "#                                               #"
echo "#################################################"
echo ""
}

variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
ls -lah /vagrant_data/.env/
. /vagrant_data/.env/.env
}

nodejs ()
{
apt-get update
apt-get install -y ca-certificates curl gnupg
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install nodejs -y
echo NODEJS_VERSION=$(node -v) >> /vagrant_data/.env/.configVariables
}

header
variables
nodejs