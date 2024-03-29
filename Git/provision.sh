#!/bin/bash
#set -x

header ()
{
echo "#################################################"
echo "#                                               #"
echo "#             GIT CONFIGURATION                 #"
echo "#                                               #"
echo "#################################################"
echo " "
}

variables ()
{
if [ ! -f /vagrant_data/.env/.env ]; then
mkdir -p /vagrant_data/.env
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
. /vagrant_data/.env/.env
}

git_config ()
{
git config --global user.name "${GIT_USER}"
git config --global user.email  ${EMAIL}
git config --global core.editor ${EDITOR}
}

header
variables
git_config
