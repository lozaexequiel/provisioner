# Environment variables

This directory contains environment variables that are used by the scripts in this repository.

## Environment variables

| Variable | Description | Default value | Tools |
| -------- | ----------- | ------------- | ----- |
| `AWS_ACCESS_KEY_ID` | AWS access key ID | | AWS CLI |
| `USER` | User | vagrant | SO |
| `HOME` | Home directory | /home/vagrant | SO |
| `PACKAGES`| package to install | unzip python3-pip git | SO |
| `ENV_FILE` | Environment file | /vagrant_data/.env/.env | SO |
| `ENV_PATH` | Environment path | /vagrant_data/.env | SO |
| `APP_NAME` | Application name | | SO |
| `APP_VOLUME` | Application volume | /var/jenkins_home | SO |
| `APP_PORT` | Application port | | SO |
| `APP_HOST_VOLUME` | Application host volume | /vagrant_data/jenkins | SO |
| `DOCKER_NETWORK` | Docker network | | Docker |
| `JENKINS_AGENT_PORT` | Jenkins agent port | 50000 | Jenkins |
| `JENKINS_AGENT_HOST` | Jenkins agent host | 50000 | Jenkins
| `JENKINS_AGENT_WORKDIR` | Jenkins agent workdir | /var/jenkins_home | Jenkins |
| `JENKINS_AGENT_HOST_VOLUME` | Jenkins agent host volume | | Jenkins |
| `JENKINS_AGENT_IMAGE` | Jenkins agent image | jenkins/jenkins:lts | Jenkins |
| `APLICATION_HOST` | Application host | 20402 | Jenkins |
| `APPLICATION_PORT` | Application port | 8080 | Jenkins |
| `IMAGE_DOCKER` | Docker image | | Docker |
| `DOCKER_USER` | Docker user | | Docker |
| `DOCKER_PASSWORD` | Docker password | | Docker |

