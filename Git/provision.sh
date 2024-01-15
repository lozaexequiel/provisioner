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
cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
fi
ls -la /vagrant_data/.env/
. /vagrant_data/.env/.env
}

git_config ()
{
git config --global user.name "${GIT_USER}"
git config --global user.email  ${EMAIL}
git config --global core.editor "vim"
}

get_commits_list ()
{
git log --pretty=format:"%h - %an, %ar : %s" > /vagrant_data/.env/commits.txt
}


header
variables
git_config
get_commits_list