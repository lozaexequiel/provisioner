#!/bin/bash
#set -x

provision ()
{
curl -s https://raw.githubusercontent.com/lozaexequiel/provisioner/main/provision.sh -o functions.sh
. functions.sh
variables
header
disable_swap
install_dependencies
ansible_provision
ansible_ssh_key
ansible_config
ansible_inventory
permission_ssh_key
clean_up
}

ansible_provision ()
{
if [ ! -d ${ANSIBLE_PATH} ]; then
mkdir -p ${ANSIBLE_PATH}
fi
if [ -z ${ANSIBLE_VERSION+x} ]; then
echo "INFO: Installing the latest version of ${EXTRA_PACKAGES}"
apt-get install -y ${EXTRA_PACKAGES}
else
echo "INFO: Installing ${EXTRA_PACKAGES} version ${ANSIBLE_VERSION}"
apt-get install -y ${EXTRA_PACKAGES}=${ANSIBLE_VERSION}
fi
${TEST_COMMAND}
}

ansible_ssh_key ()
{
  case $(hostname) in
    *ansible*)
    if [ ! -f ${PRIVATE_KEY_FILE} ]; then
      mkdir -p ${SSH_DIR}
      chmod 700 ${SSH_DIR}
      cd ${SSH_DIR}
      echo "User: ${USER}"
      ssh-keygen -t rsa -b 4096 -C "${USER}@${hostname}" -f ${PRIVATE_KEY_FILE} -N "" 
      chown -R ${USER}:${USER} ${SSH_DIR}
      eval "$(ssh-agent -s)"
      ssh-add ${PRIVATE_KEY_FILE}
      mkdir -p $(dirname ${REMOTE_PUBLIC_KEY_FILE})
      cp ${PUBLIC_KEY_FILE} ${REMOTE_PUBLIC_KEY_FILE}      
      echo "INFO: The public key has been copied to the remote server"
    else
      echo "INFO: A private key already exists"
    fi
    ;;
    *)
    cat ${REMOTE_PUBLIC_KEY_FILE} >> ${HOME}/authorized_keys
    ;;    
  esac   
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
}

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
      echo "INFO: INVENTORY_FILE file created, you can find the file in ${ANSIBLE_PATH}"      
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

provision