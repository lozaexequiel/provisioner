#!/bin/bash
#set -x
header ()
{
echo "#################################################"
echo "#                                               #"
echo "#              ANSIBLE PROVISIONER              #"
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

create_ssh_key ()
{
if [ ! -f ${HOME}/.ssh/mykey ]; then
mkdir -p ${HOME}/.ssh
ssh-keygen -t rsa -b 4096 -C "${USER}@${HOSTNAME}" -f ${HOME}/.ssh/mykey -q -N ""
chown -R ${USER}:${USER} ${HOME}/.ssh
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/mykey
fi
}

permission_ssh_key ()
{
chmod 700 ${ANSIBLE_DIR}/.ssh
chmod 600 ${ANSIBLE_DIR}/.ssh/authorized_keys
chown -R ${USER}:${USER} ${ANSIBLE_DIR}/.ssh
}

ansible_provision ()
{
if [[ ! $(hostname) =~ (master|node) ]]; then
  echo "Error: The hostname must contain 'master' or 'node' to run this script"
  echo "Error in function : ${FUNCNAME[0]}"
  exit 1
fi
apt update
if [ -z ${ANSIBLE_VERSION+x} ]; then
apt install -y ansible
else
apt install -y ansible=${ANSIBLE_VERSION}
fi
ansible --version
}

ansible_config ()
{   case $(hostname) in
    *master*)
    if [ -f ${ANSIBLE_CONFIG} ]; then
      cp ${ANSIBLE_CONFIG} ${ANSIBLE_DIR}
    else
      echo "Error: The ANSIBLE_CONFIG file does not exist"
      echo "Error in function : ${FUNCNAME[0]}"
      exit 1
    fi
    if [ -f ${ANSIBLE_DIR}/.ssh/mykey.pub ]; then
      cp ${ANSIBLE_DIR}/.ssh/mykey.pub ${ANSIBLE_PATH}/.ssh
    else
      echo "Error: The public ssh key file does not exist"
      echo "Error in function : ${FUNCNAME[0]}"
      exit 1
    fi
    ;;
    *node*)    
        cat ${ANSIBLE_PATH}/.ssh/mykey.pub >> ${ANSIBLE_DIR}/.ssh/authorized_keys
      ;;
    *)
            echo "Error: The authorized_keys file does not exist"
        echo "Error in function : ${FUNCNAME[0]}"
        exit 1
        ;;
  esac
       
}

ansible_inventory ()
{
    case $(hostname) in
    *master*)      
    if [ -f ${INVENTORY_FILE} ]; then
  cp ${INVENTORY_FILE} ${ANSIBLE_DIR}
else
      echo "INFO: The INVENTORY_FILE file does not exist, creating a new one"
      echo "[master]" > ${INVENTORY_FILE}
      echo "" >> ${INVENTORY_FILE}
      echo "[node]" >> ${INVENTORY_FILE}
      echo "" >> ${INVENTORY_FILE}
      echo "[other]" >> ${INVENTORY_FILE}
      awk -v hostline="${hostname} ansible_host=${ipAddress} ansible_user=${USER} ansible_ssh_private_key_file=${ANSIBLE_DIR}/.ssh/mykey" '/\[master\]/ { print; print hostline; next }1' "${INVENTORY_FILE}" > temp && mv temp "${INVENTORY_FILE}"
      echo "master host added to the [master] group"
    fi
    ;;      
    *node*)
      awk -v hostline="${hostname} ansible_host=${ipAddress} ansible_user=${USER} ansible_ssh_private_key_file=${ANSIBLE_DIR}/.ssh/mykey" '/\[node\]/ { print; print hostline; next }1' "${INVENTORY_FILE}" > temp && mv temp "${INVENTORY_FILE}"
      echo "node host added to the [node] group"
      ;;
    *)
      echo "WARNING: The hostname must contain 'master' or 'node' to run this script"
      echo "the host will be added to the [other] group"
      awk -v hostline="${hostname} ansible_host=${ipAddress} ansible_user=${USER} ansible_ssh_private_key_file=${ANSIBLE_DIR}/.ssh/mykey" '/\[other\]/ { print; print hostline; next }1' "${INVENTORY_FILE}" > temp && mv temp "${INVENTORY_FILE}"
      ;;
  esac
}

ansible_configuration ()
{
if [ ! -d ${ANSIBLE_PATH} ]; then
mkdir -p ${ANSIBLE_PATH}
fi
hostname=$(hostname)
ipAddress=$(hostname -I | awk '{print $2}') # Get the second IP address because the first one is the localhost or the private IP
case "$hostname" in
  *master*)
	create_ssh_key
  echo "Configuring ansible master with hostname: $hostname"
  ansible_config
  ansible_inventory
  permission_ssh_key
  echo "hostname: $hostname provisioned successfully"
    ;;
  *node*)
	echo "Giving access to the master node with hostname: $hostname"    
  ansible_config
  ansible_inventory
  permission_ssh_key
  echo "hostname: $hostname provisioned successfully"
    ;;
  *)
    echo "Error: The hostname must contain 'master' or 'node' to run this script"
    exit 1
    ;;
esac
}

header
variables
ansible_provision
ansible_configuration