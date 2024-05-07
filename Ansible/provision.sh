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
permission_ssh_key
ansible_config
ansible_inventory
ansible_create_vars
ansible_collection_install
ubuntu_pro_login
clean_up
}

ansible_provision ()
{
  if [ ! -d ${ANSIBLE_PATH} ]; then
    mkdir -p ${ANSIBLE_PATH}
  fi

  echo "$(date) INFO: Updating package lists"
  apt-get update || { echo "$(date) ERROR: Failed to update package lists"; exit 1; }

  if [ -z ${ANSIBLE_VERSION+x} ]; then
    echo "$(date) INFO: Installing the latest version of ${EXTRA_PACKAGES}"
    apt-get install -y ${EXTRA_PACKAGES} || { echo "$(date) ERROR: Failed to install ${EXTRA_PACKAGES}"; exit 1; }
  else
    echo "$(date) INFO: Installing ${EXTRA_PACKAGES} version ${ANSIBLE_VERSION}"
    apt-get install -y ${EXTRA_PACKAGES}=${ANSIBLE_VERSION} || { echo "$(date) ERROR: Failed to install ${EXTRA_PACKAGES} version ${ANSIBLE_VERSION}"; exit 1; }
  fi

  ${TEST_COMMAND} || { echo "$(date) ERROR: Test command failed"; exit 1; }
}

ansible_config ()
{
  case $(hostname) in
    *ansible*)
      if [ ! -d ${ANSIBLE_DIR} ]; then
        echo "$(date) INFO: Creating Ansible directory"
        mkdir -p ${ANSIBLE_DIR} || { echo "$(date) WARNING: Failed to create ${ANSIBLE_DIR}"; }
      fi

      if [ -f ${ANSIBLE_CONFIG} ]; then
        cp ${ANSIBLE_CONFIG} ${ANSIBLE_DIR}/ansible.cfg || { echo "$(date) WARNING: Failed to copy ${ANSIBLE_CONFIG}"; }
        echo "$(date) INFO: The ansible.cfg file already exists, you can find the file in ${ANSIBLE_PATH}"
      else
        echo "$(date) INFO: The ansible.cfg file does not exist, creating a new one"
        {
          echo "[defaults]"
          echo "inventory = ${INVENTORY_FILE}"
          echo "remote_user = ${USER}"
          echo "private_key_file = ${PRIVATE_KEY_FILE}"
          echo "remote_tmp = ${REMOTE_TMP}"
          echo "become_user = ${BECOME_USER}"
          echo "roles_path = ${ROLES_PATH}"
        } > ${ANSIBLE_DIR}/ansible.cfg || { echo "$(date) WARNING: Failed to create ${ANSIBLE_DIR}/ansible.cfg"; }
        cp ${ANSIBLE_DIR}/ansible.cfg ${ANSIBLE_PATH} || { echo "$(date) WARNING: Failed to copy ${ANSIBLE_DIR}/ansible.cfg"; }
        echo "$(date) INFO: ansible.cfg file created, you can find the file in ${ANSIBLE_PATH}"
      fi
      ;;
  esac
}

ansible_inventory ()
{
    case $(hostname) in
    *ansible*)
    if [ ! -d ${ANSIBLE_PATH} ]; then
      echo "$(date) INFO: Creating Ansible directory"
      mkdir -p ${ANSIBLE_PATH} || { echo "$(date) ERROR: Failed to create ${ANSIBLE_PATH}"; exit 1; }
    fi

    if [ -f ${INVENTORY_FILE} ]; then
      echo "$(date) INFO: The INVENTORY_FILE file already exists"
    else
      echo "$(date) INFO: The INVENTORY_FILE file does not exist, creating a new one"
      {
        echo "[master]"
        echo ""
        echo "[node]"
        echo ""
        echo "[other]"
      } > ${INVENTORY_FILE} || {
        echo "$(date) ERROR: Failed to create INVENTORY_FILE"
        exit 1
      }
      echo "$(date) INFO: INVENTORY_FILE file created, you can find the file in ${ANSIBLE_PATH}"
    fi
    ;;
    *master*)
      group="master"
      ;;
    *node*)
      group="node"
      ;;
    *)
      group="other"
      ;;
  esac

  temp_file=$(mktemp)
  awk -v hostline="${hostname} ansible_host=${ipAddress} ansible_user=${USER} ansible_ssh_private_key_file=${PRIVATE_KEY_FILE}" '/\['"$group"'\]/ { print; print hostline; next }1' "${INVENTORY_FILE}" > "$temp_file" && mv "$temp_file" "${INVENTORY_FILE}" || {
    echo "$(date) ERROR: Failed to update INVENTORY_FILE"
    exit 1
  }
  echo "$(date) INFO: ${hostname} host added to the [$group] group"
}

ansible_create_vars ()
{ 
  case $(hostname) in
    *ansible*)
    if [ -f ${PLAYBOOK_VARS} ]; then
      echo "$(date) INFO: The PLAYBOOK_VARS file already exists"
    else
      echo "$(date) INFO: The PLAYBOOK_VARS file does not exist, trying to download from remote location"
      if ! command -v curl &> /dev/null; then
        echo "$(date) ERROR: curl could not be found. Please install it and try again"
        exit 1
      fi
      if curl -L ${EXAMPLE_TOOL_FILE} -o ${PLAYBOOK_VARS}; then
        echo "$(date) INFO: PLAYBOOK_VARS file downloaded successfully"
      else
        echo "$(date) ERROR: Failed to download the example file. Please check the URL or your network connection"
        exit 1
      fi
    fi
    ;;
    *)
    echo "$(date) INFO: no actions for this host"
    ;;
  esac
}

ansible_collection_install ()
{
  if [ -n "${COLLECTIONS}" ]; then
    echo "$(date) INFO: Installing Ansible collections"
    # Check if ansible-galaxy is available
    if ! command -v ansible-galaxy &> /dev/null; then
      echo "$(date) ERROR: ansible-galaxy could not be found. Please install it and try again"
      exit 1
    fi
    if ansible-galaxy collection install ${COLLECTIONS}; then
      echo "$(date) INFO: Ansible collections installed successfully"
    else
      echo "$(date) ERROR: Failed to install Ansible collections"
      exit 1
    fi
  else
    echo "$(date) INFO: No collections detected"
  fi
}

ansible_ssh_key ()
{
  case $(hostname) in *ansible*)
  mkdir -p ${SSH_DIR}
  private_key
  public_key
  ;;
  *)
  public_key
  ;;
  esac
  permission_ssh_key
}

private_key ()

{
  mkdir -p $(dirname ${REMOTE_PRIVATE_KEY_FILE}) || { echo "$(date) ERROR: Failed to create directory for REMOTE_PRIVATE_KEY_FILE"; exit 1; }
  if [ -f ${REMOTE_PRIVATE_KEY_FILE} ]; then
    cp -f ${REMOTE_PRIVATE_KEY_FILE} ${PRIVATE_KEY_FILE} || { echo "$(date) ERROR: Failed to copy private key"; exit 1; }
    echo "$(date) INFO: The private key has been copied to the local path"
  else
    if [ ! -f ${PRIVATE_KEY_FILE} ]; then
      create_ssh_key
      echo "$(date) INFO: A new SSH key pair has been created"
      if [ -f ${PRIVATE_KEY_FILE} ]; then
        cp -f ${PRIVATE_KEY_FILE} ${REMOTE_PRIVATE_KEY_FILE} || { echo "$(date) ERROR: Failed to copy private key"; exit 1; }
        echo "$(date) INFO: The private key has been copied to the remote path"
      fi
    else
      echo "$(date) WARNING: No remote private key found"
      echo "$(date) INFO: The private key already exists"
      cp -f ${PRIVATE_KEY_FILE} ${REMOTE_PRIVATE_KEY_FILE} || { echo "$(date) ERROR: Failed to copy private key"; exit 1; }
      echo "$(date) INFO: The private key has been copied to the remote path"
    fi
  fi
}

public_key ()
{
  mkdir -p $(dirname ${REMOTE_PUBLIC_KEY_FILE}) || { echo "$(date) ERROR: Failed to create directory for REMOTE_PUBLIC_KEY_FILE"; exit 1; }
  if [ -f ${REMOTE_PUBLIC_KEY_FILE} ]; then
    if ! grep -q "$(cat ${REMOTE_PUBLIC_KEY_FILE})" ${SSH_DIR}/authorized_keys; then
      cat ${REMOTE_PUBLIC_KEY_FILE} >> ${SSH_DIR}/authorized_keys || { echo "$(date) ERROR: Failed to add public key to authorized_keys"; exit 1; }
      echo "$(date) INFO: The public key has been added to the authorized_keys file"
    else
      echo "$(date) INFO: The public key is already in the authorized_keys file"
    fi
  else
    ssh-keygen -y -f ${PRIVATE_KEY_FILE} > ${REMOTE_PUBLIC_KEY_FILE} || { echo "$(date) ERROR: Failed to create public key"; exit 1; }
    echo "$(date) INFO: The public key has been created in the remote path"
    cat ${REMOTE_PUBLIC_KEY_FILE} >> ${SSH_DIR}/authorized_keys || { echo "$(date) ERROR: Failed to add public key to authorized_keys"; exit 1; }
    if ! grep -q "$(cat ${REMOTE_PUBLIC_KEY_FILE})" ${SSH_DIR}/authorized_keys; then
      echo "$(date) ERROR: The public key is not in the authorized_keys file"
      exit 1
    else
      echo "$(date) INFO: The public key has been added to the authorized_keys file"
    fi
  fi
}

permission_ssh_key ()
{
  chmod 700 ${SSH_DIR} || { echo "$(date) ERROR: Failed to change permissions for SSH_DIR"; exit 1; }
  chmod 600 ${HOME}/.ssh/authorized_keys || { echo "$(date) ERROR: Failed to change permissions for authorized_keys"; exit 1; }
  chown -R ${USER}:${USER} ${SSH_DIR} || { echo "$(date) ERROR: Failed to change owner for SSH_DIR"; exit 1; }
}

provision