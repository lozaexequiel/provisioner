#!/bin/bash
#set -x
variables ()
{
. /vagrant_data/.env/.env
}
deploy ()
{
docker stop ${APP_NAME}
docker rm ${APP_NAME}
docker rmi ${DOCKER_IMAGE}
docker network rm ${DOCKER_NETWORK}
docker pull ${DOCKER_IMAGE}
docker network create ${DOCKER_NETWORK}
docker run -d --name jenkins --restart unless-stopped -p ${APPLICATION_HOST}:${APPLICATION_PORT} -p ${JENKINS_AGENT_HOST}:${JENKINS_AGENT_PORT} --network ${DOCKER_NETWORK} -v /var/run/docker.sock:/var/run/docker.sock -v ${APP_HOST_VOLUME}:${APP_VOLUME} ${DOCKER_IMAGE}
}

variables
deploy