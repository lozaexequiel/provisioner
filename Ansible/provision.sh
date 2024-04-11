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
ansible_create_vars
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
    if [ -f ${REMOTE_PRIVATE_KEY_FILE} ]; then
    echo "INFO: The private key already exists in the remote path"
    else
    echo "INFO: The private key does not exist in the remote path, creating a new one"    
    if [ ! -f ${PRIVATE_KEY_FILE} ]; then
      mkdir -p ${SSH_DIR}      
      cd ${SSH_DIR}
      ssh-keygen -t rsa -b 4096 -C "${USER}@${hostname}" -f ${PRIVATE_KEY_FILE} -N ""
      chown -R ${USER}:${USER} ${SSH_DIR}
      eval "$(ssh-agent -s)"
      ssh-add ${PRIVATE_KEY_FILE}
      mkdir -p $(dirname ${REMOTE_PUBLIC_KEY_FILE})
      cp -f ${PUBLIC_KEY_FILE} ${REMOTE_PUBLIC_KEY_FILE}
      echo "INFO: The public key has been copied to the remote path"
      cp -f ${PRIVATE_KEY_FILE} ${REMOTE_PRIVATE_KEY_FILE}
      echo "INFO: The private key has been copied to the remote path"      
      else
      echo "INFO: The private key already exists in the local path"
      cp -f ${PRIVATE_KEY_FILE} ${REMOTE_PRIVATE_KEY_FILE}
      echo "INFO: The private key has been copied to the remote path"
      if [ -f ${PUBLIC_KEY_FILE} ]; then
        cp ${PUBLIC_KEY_FILE} ${REMOTE_PUBLIC_KEY_FILE}
        echo "INFO: The public key has been copied to the remote path"
      fi
    fi
    fi
    ;;
      *)
      cat ${REMOTE_PUBLIC_KEY_FILE} >> ${SSH_DIR}/authorized_keys
      echo "INFO: Configured with the public key of the ansible server"
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
      echo "INFO: ${hostname} host added to the [master] group"
      ;;
    *node*)
      awk -v hostline="${hostname} ansible_host=${ipAddress} ansible_user=${USER} ansible_ssh_private_key_file=${PRIVATE_KEY_FILE}" '/\[node\]/ { print; print hostline; next }1' "${INVENTORY_FILE}" > temp && mv temp "${INVENTORY_FILE}"
      echo "INFO: ${hostname} host added to the [node] group"
      ;;
    *)
      echo "WARNING: The hostname must contain 'master' or 'node' to run this script, next steps could be affected"
      echo "WARNING: ${hostname} host added to the [other] group"
      awk -v hostline="${hostname} ansible_host=${ipAddress} ansible_user=${USER} ansible_ssh_private_key_file=${PRIVATE_KEY_FILE}" '/\[other\]/ { print; print hostline; next }1' "${INVENTORY_FILE}" > temp && mv temp "${INVENTORY_FILE}"
      ;;
  esac
}

ansible_create_vars ()
{
  case $(hostname) in
    *ansible*)
    if [ -f ${PLAYBOOK_VARS} ]; then
      echo "INFO: The PLAYBOOK_VARS file already exists"
    else
      echo "INFO: The PLAYBOOK_VARS file does not exist, creating a new one"
      echo "---" > ${PLAYBOOK_VARS}
      echo "ansible_user: ${USER}" >> ${PLAYBOOK_VARS}
      echo "ansible_ssh_private_key_file: ${PRIVATE_KEY_FILE}" >> ${PLAYBOOK_VARS}
      echo "INFO: PLAYBOOK_VARS file created, you can find the file in ${ANSIBLE_PATH}"
    fi
    ;;
    *)
    echo "INFO: no actions for this host"
    ;;
  esac
}

provision