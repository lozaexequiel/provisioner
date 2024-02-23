#!/bin/bash
#set -x
header ()
{
echo "#################################################"
echo "#                                               #"
echo "#            BLOCKCHAIN PROVISIONER             #"
echo "#                                               #"
echo "#################################################"
}

variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
mkdir -p /vagrant_data/.env
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
. /vagrant_data/.env/.env
}

test_quorum_deployment ()
{
if [ -d "${COMPOSE_PATH}" ]; then
        rm -rf quorum-examples
fi
git clone ${REPO_URL} ${COMPOSE_PATH}
cd ${COMPOSE_PATH}
docker-compose up -d
}

header
variables
test_quorum_deployment