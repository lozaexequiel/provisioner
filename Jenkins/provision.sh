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
while true
do
  response=$(curl --write-out '%{http_code}' --silent --output /dev/null http://${APPLICATION_HOST}:${APPLICATION_PORT})

  if [ $response -eq 200 ]
  then
    echo "Jenkins is up"
    break
  else
    echo "Waiting for Jenkins..."
    sleep 5
  fi
done
docker exec -it jenkins bash -c "cat /var/jenkins_home/secrets/initialAdminPassword" > /vagrant_data/.env/initialPasswordJenkins.env
}

variables
install_jenkins