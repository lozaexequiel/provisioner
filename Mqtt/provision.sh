#!/bin/bash
#set -x
variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
mkdir -p /vagrant_data/.env
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
. /vagrant_data/.env/.env
}
install_mqtt ()
{
docker pull ${DOCKER_IMAGE}:${DOCKER_TAG}
docker compose up -d --env-file ${ENV_FILE}
}
variables
install_mqtt