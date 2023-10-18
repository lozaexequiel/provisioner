#!/bin/bash
#set -x
variables ()
{
. /vagrant_data/.env/.env
}
install_mqtt ()
{
docker pull ${DOCKER_IMAGE}
docker network create ${DOCKER_NETWORK}
docker run -d --name ${APPLICATION_NAME} --restart unless-stopped -p ${APPLICATION_HOST}:${APPLICATION_PORT} --network ${DOCKER_NETWORK} -v ${APP_HOST_VOLUME}:${APP_VOLUME} ${DOCKER_IMAGE}

}

variables
install_mqtt