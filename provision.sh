#!/bin/bash
#set -x
header ()
{
echo ""
echo "#################################################"
echo "#                                               #"
echo "            ${PROVISIONER_NAME} provisioner      "
echo "#                                               #"
echo "#################################################"
echo ""
}

variables ()
{
set -a
hostname=$(hostname)
ipAddress=$(hostname -I | awk '{print $2}') # Get the second IP address because the first one is the localhost or the private IP address
if [ ! -d /vagrant_data/.env ]; then
echo "INFO: The .env directory does not exist or is not detected"
echo "Creating .env directory in /vagrant_data"
mkdir -p /vagrant_data/.env
fi
if [ -f /vagrant_data/.env/.env ] && [ -s /vagrant_data/.env/.env ]; then
echo "Sourcing environment variables from file"
. /vagrant_data/.env/.env
else
echo "INFO: The .env file does not exist, is not detected, or the file is empty"
if [ -f /vagrant_data/example/.env.example ]; then
echo "INFO: Example file detected, creating .env file from example"
cp /vagrant_data/example/.env.example /vagrant_data/.env/.env
else
echo "INFO: Creating an empty .env file"
touch /vagrant_data/.env/.env
echo "ERROR: Please fill in the .env file with the required variables and run the script again"
echo "For more information, please refer to the main repository https://github.com/lozaexequiel/provisioner"
exit 1
fi
fi
set +a
}

disable_swap ()
{
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
swapoff -a
}

install_dependencies ()
{
apt-get update
apt-get install -y ${PACKAGES}
echo "INFO: Dependencies installed, continuing with the installation in ${hostname}"
}

clean_up ()
{
apt-get autoremove -y
apt-get clean
echo "INFO: The ${PROVISIONER_NAME} has been successfully provisioned in ${hostname} with IP address ${ipAddress}"
}

permission_ssh_key ()
{
chmod 700 ${SSH_DIR}
chmod 600 ${HOME}/.ssh/authorized_keys
chown -R ${USER}:${USER} ${SSH_DIR}
}