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
if [ -d "${COMPOSE_PATH}" ]; then
        rm -rf quorum-examples
fi
git clone ${REPO_URL} ${COMPOSE_PATH}
docker-compose -f ${COMPOSE_PATH} up -d
}

variables
test_quorum_deployment