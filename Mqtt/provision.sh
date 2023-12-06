#!/bin/bash
#set -x
variables ()
{
. /vagrant_data/.env/.env
}
install_mqtt ()
{
docker pull ${DOCKER_IMAGE}:${DOCKER_TAG}
docker compose up -d --env-file ${ENV_FILE}
}
variables
install_mqtt