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

ansible_provision ()
{
apt update
if [ ! -d ${ANSIBLE_PATH} ]; then
mkdir -p ${ANSIBLE_PATH}
fi
hostname=$(hostname)
ipAddress=$(hostname -I | awk '{print $2}') # Get the second IP address because the first one is the localhost or the private IP
if [ -z ${ANSIBLE_VERSION+x} ]; then
echo "INFO: Installing the latest version of ansible"
apt install -y ansible
else
echo "INFO: Installing ansible version: ${ANSIBLE_VERSION}"
apt install -y ansible=${ANSIBLE_VERSION}
fi
ansible --version
}

ansible_ssh_key ()
{
  case $(hostname) in
    *ansible*)
    if [ ! -f ${PRIVATE_KEY_FILE} ]; then
      mkdir -p ${SSH_DIR}
      ssh-keygen -t rsa -b 4096 -C "${USER}@${HOSTNAME}" -f ${PRIVATE_KEY_FILE} -q -N ""
      chown -R ${USER}:${USER} ${SSH_DIR}
      eval "$(ssh-agent -s)"
      ssh-add ${PRIVATE_KEY_FILE}
      mkdir -p $(dirname ${REMOTE_PUBLIC_KEY_FILE})
      cp ${PUBLIC_KEY_FILE} ${REMOTE_PUBLIC_KEY_FILE}
      echo "INFO: The ssh key has been created, you can find it in ${REMOTE_PUBLIC_KEY_FILE}"
    else
      echo "INFO: A private key already exists"
    fi
    ;;
    *)
    cat ${REMOTE_PUBLIC_KEY_FILE} >> ${SSH_DIR}/authorized_keys
    ;;    
  esac   
}

permission_ssh_key ()
{
chmod 700 ${SSH_DIR}
chmod 600 ${SSH_DIR}/authorized_keys
chown -R ${USER}:${USER} ${SSH_DIR}
}



ansible_config ()
{   
  case $(hostname) in
    *ansible*)    
    if [ -f ${ANSIBLE_CONFIG} ]; then
      cp ${ANSIBLE_CONFIG} ${ANSIBLE_DIR}/ansible.cfg
      echo "INFO: The ansible.cfg file already exists, you can find the file in ${ANSIBLE_PATH}"
    else
      echo "INFO: The ansible.cfg file does not exist, creating a new one"
      echo "[defaults]" > ${ANSIBLE_DIR}/ansible.cfg
      echo "inventory = ${INVENTORY_FILE}" >> ${ANSIBLE_DIR}/ansible.cfg
      echo "remote_user = ${USER}" >> ${ANSIBLE_DIR}/ansible.cfg
      echo "private_key_file = ${PRIVATE_KEY_FILE}" >> ${ANSIBLE_DIR}/ansible.cfg
      echo "remote_tmp = ${REMOTE_TMP}" >> ${ANSIBLE_DIR}/ansible.cfg
      echo "become_user = ${BECOME_USER}" >> ${ANSIBLE_DIR}/ansible.cfg
      echo "roles_path = ${ROLES_PATH}" >> ${ANSIBLE_DIR}/ansible.cfg
      cp ${ANSIBLE_DIR}/ansible.cfg ${ANSIBLE_PATH}
      echo "INFO: ansible.cfg file created, you can find the file in ${ANSIBLE_PATH}"
    fi
    ;;
    *)    
    ;;
  esac  

ansible_inventory ()
{
    case $(hostname) in
    *ansible*)      
    if [ -f ${INVENTORY_FILE} ]; then
      echo "INFO: The INVENTORY_FILE file already exists"
else
      echo "INFO: The INVENTORY_FILE file does not exist, creating a new one"
      echo "[master]" > ${INVENTORY_FILE}
      echo "" >> ${INVENTORY_FILE}
      echo "[node]" >> ${INVENTORY_FILE}
      echo "" >> ${INVENTORY_FILE}
      echo "[other]" >> ${INVENTORY_FILE}
      echo "" >> ${INVENTORY_FILE}
      echo "INVENTORY_FILE file created successfully"
      echo "you can find the file in ${ANSIBLE_PATH}"
    fi
    ;;      
    *master*)
      awk -v hostline="${hostname} ansible_host=${ipAddress} ansible_user=${USER} ansible_ssh_private_key_file=${PRIVATE_KEY_FILE}" '/\[master\]/ { print; print hostline; next }1' "${INVENTORY_FILE}" > temp && mv temp "${INVENTORY_FILE}"
      echo "master host added to the [master] group"
      ;;
    *node*)
      awk -v hostline="${hostname} ansible_host=${ipAddress} ansible_user=${USER} ansible_ssh_private_key_file=${PRIVATE_KEY_FILE}" '/\[node\]/ { print; print hostline; next }1' "${INVENTORY_FILE}" > temp && mv temp "${INVENTORY_FILE}"
      echo "node host added to the [node] group"
      ;;
    *)
      echo "WARNING: The hostname must contain 'master' or 'node' to run this script"
      echo "the host will be added to the [other] group"
      awk -v hostline="${hostname} ansible_host=${ipAddress} ansible_user=${USER} ansible_ssh_private_key_file=${PRIVATE_KEY_FILE}" '/\[other\]/ { print; print hostline; next }1' "${INVENTORY_FILE}" > temp && mv temp "${INVENTORY_FILE}"
      ;;
  esac
}

header
variables
ansible_provision
ansible_ssh_key
ansible_config
permission_ssh_key
ansible_inventory