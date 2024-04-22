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
ansible_collection_install
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

# Function to create ansible ssh key
ansible_ssh_key ()
{
  # Check if the ssh directory exists
  if [ ! -d "$(dirname ${REMOTE_PUBLIC_KEY_FILE})" ]; then
    mkdir -p "$(dirname ${REMOTE_PUBLIC_KEY_FILE})"
  fi

  # Remote private key file check
  if [ -f ${REMOTE_PRIVATE_KEY_FILE} ]; then
    echo "INFO: Ansible provisioned with custom private key"
    case $(hostname) in
      *ansible*)
        # Copy the remote private key file to the local path
        cp -f ${REMOTE_PRIVATE_KEY_FILE} ${PRIVATE_KEY_FILE}
        echo "INFO: The private key has been copied to the local path"
      ;;
      *)
        if [ -f ${REMOTE_PUBLIC_KEY_FILE} ]; then
          # Check if the public key is in the authorized_keys file
          if ! grep -q "$(cat ${REMOTE_PUBLIC_KEY_FILE})" ${SSH_DIR}/authorized_keys; then
            # Add the public key to the authorized_keys file
            cat ${REMOTE_PUBLIC_KEY_FILE} >> ${SSH_DIR}/authorized_keys
            echo "INFO: The public key has been added to the authorized_keys file"
          fi
        else
          # Create the public key file
          ssh-keygen -y -f ${REMOTE_PRIVATE_KEY_FILE} > ${REMOTE_PUBLIC_KEY_FILE}
          echo "INFO: The public key has been created in the remote path"
          # Add the public key to the authorized_keys file
          cat ${REMOTE_PUBLIC_KEY_FILE} >> ${SSH_DIR}/authorized_keys
          echo "INFO: The public key has been added to the authorized_keys file"
        fi
      ;;
    esac
  else
    case $(hostname) in
      *ansible*)
        # Check if the local private key file already exists
        if [ ! -f ${PRIVATE_KEY_FILE} ]; then
          create_ssh_key
        else
          echo "INFO: The private key already exists in the local path"
        fi
        # Copy the private key file to the remote path
        cp -f ${PRIVATE_KEY_FILE} ${REMOTE_PRIVATE_KEY_FILE}
        echo "INFO: The private key has been copied to the remote path"
        # Check if the remote public key file already exists
        if [ ! -f ${REMOTE_PUBLIC_KEY_FILE} ]; then
          # Create the public key file
          ssh-keygen -y -f ${REMOTE_PRIVATE_KEY_FILE} > ${REMOTE_PUBLIC_KEY_FILE}
          echo "INFO: The public key has been created in the remote path"
        fi
        # Check if the public key is in the authorized_keys file
        if ! grep -q "$(cat ${REMOTE_PUBLIC_KEY_FILE})" ${SSH_DIR}/authorized_keys; then
          # Add the public key to the authorized_keys file
          cat ${REMOTE_PUBLIC_KEY_FILE} >> ${SSH_DIR}/authorized_keys
          echo "INFO: The public key has been added to the authorized_keys file"
        fi
      ;;
      *)
        # no actions for this host
        echo "INFO: No actions for this host"
      ;;
    esac
  fi
}

# Function to configure Ansible
ansible_config ()
{
  # Check if the hostname includes "ansible"
  case $(hostname) in
    *ansible*)
      # Check if the Ansible configuration file already exists
      if [ -f ${ANSIBLE_CONFIG} ]; then
        # Copy the existing configuration file
        cp ${ANSIBLE_CONFIG} ${ANSIBLE_DIR}/ansible.cfg
        echo "INFO: The ansible.cfg file already exists, you can find the file in ${ANSIBLE_PATH}"
      else
        # Create a new configuration file
        echo "INFO: The ansible.cfg file does not exist, creating a new one"
        echo "[defaults]" > ${ANSIBLE_DIR}/ansible.cfg
        echo "inventory = ${INVENTORY_FILE}" >> ${ANSIBLE_DIR}/ansible.cfg
        echo "remote_user = ${USER}" >> ${ANSIBLE_DIR}/ansible.cfg
        echo "private_key_file = ${PRIVATE_KEY_FILE}" >> ${ANSIBLE_DIR}/ansible.cfg
        echo "remote_tmp = ${REMOTE_TMP}" >> ${ANSIBLE_DIR}/ansible.cfg
        echo "become_user = ${BECOME_USER}" >> ${ANSIBLE_DIR}/ansible.cfg
        echo "roles_path = ${ROLES_PATH}" >> ${ANSIBLE_DIR}/ansible.cfg
        # Copy the new configuration file to the Ansible path
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
      echo "INFO: The PLAYBOOK_VARS file does not exist, trying to download from remote location"
      curl -s ${EXAMPLE_TOOL_FILE} -o ${PLAYBOOK_VARS}
      if [ -f ${PLAYBOOK_VARS} ]; then
        echo "INFO: PLAYBOOK_VARS file downloaded successfully"
      else
        echo "ERROR: ${EXAMPLE_TOOL_FILE} does not exist or failed to download"
        echo "ERROR: Failed to download the example file. Please check the URL or your network connection"
        exit 1
    fi
    ;;
    *)
    echo "INFO: no actions for this host"
    ;;
  esac
}

ansible_collection_install ()
{
  if [ -n "${COLLECTIONS}" ]; then
    echo "INFO: Installing Ansible collections"
    ansible-galaxy collection install ${COLLECTIONS}
  fi
}

provision