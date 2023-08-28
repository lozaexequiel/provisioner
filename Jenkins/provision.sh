#!/bin/bash
#set -x
variables ()
{
. /vagrant_data/.env/.env
}
install_jenkins ()
{
docker pull ${DOCKER_IMAGE}
docker network create ${DOCKER_NETWORK}
docker run -d --name jenkins --restart unless-stopped -p ${APPLICATION_HOST}:${APPLICATION_PORT} -p ${JENKINS_AGENT_HOST}:${JENKINS_AGENT_PORT} --network ${DOCKER_NETWORK} -v /var/run/docker.sock:/var/run/docker.sock -v ${APP_HOST_VOLUME}:${APP_VOLUME} ${DOCKER_IMAGE} 
docker exec -it jenkins bash -c "cat /var/jenkins_home/secrets/initialAdminPassword" > /vagrant_data/.env/initialPasswordJenkins.env
}

variables
install_jenkins