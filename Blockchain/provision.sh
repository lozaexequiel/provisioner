#!/bin/bash
#set -x
variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
ls -la /vagrant_data/.env/
. /vagrant_data/.env/.env
}
test_quorum_deployment ()
{
git clone https://github.com/Consensys/quorum-examples.git
docker-compose -f ${COMPOSE_PATH} up -d
}

variables
test_quorum_deployment