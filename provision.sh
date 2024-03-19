#!/bin/bash
#set -x
header ()
{
echo "#################################################"
echo "#                                               #"
echo "#                   PROVISIONER                 #"
echo "#                                               #"
echo "#################################################"
echo ""
}

variables ()
{
if [ ! -d /vagrant_data/.env ]; then
echo "WARNING! The .env directory does not exist or is not detected"
echo "Creating .env directory in /vagrant_data"
mkdir -p /vagrant_data/.env
fi
if [ ! -f /vagrant_data/.env/.env ]; then
  echo "WARNING! The .env file does not exist or is not detected"
  if [ -f /vagrant_data/.env/.env.example ]; then
    echo "Example file detected, creating .env file from example"
    cp /vagrant_data/.env/.env.example /vagrant_data/.env/.env
  else
    echo "Creating an empty .env file"
    touch /vagrant_data/.env/.env
    echo "Please fill in the .env file with the required variables and run the script again"
    echo "For more information, please refer to the main repository https://github.com/lozaexequiel/provisioner"
    exit 1
  fi
fi
echo "Sourcing environment variables from /vagrant_data/.env/.env"
. /vagrant_data/.env/.env
}

disable_swap ()
{
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
swapoff -a
}

install_dependencies ()
{
apt update
apt upgrade -y
apt install -y ${PACKAGES}
}

clean_up ()
{
apt autoremove -y
apt clean
}

header
variables
disable_swap
install_dependencies
clean_up