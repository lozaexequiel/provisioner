#!/bin/bash
# remove comment if you want to enable debugging
#set -x
header ()
{
echo "#################################################"
echo "#                                               #"
echo "#              DOCKER PROVISIONER               #"
echo "#                                               #"
echo "#################################################"
variables ()
{
USER="vagrant"
}

docker_provision ()
{
# Add Docker's official GPG key:
apt update
apt install ca-certificates curl gnupg -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
usermod -G docker ${USER}
systemctl enable docker
apt install -y docker-compose
systemctl restart docker
systemctl status docker | grep Active
}
header
variables
docker_provision