#!/bin/bash
#set -x
header ()
{
echo ""
echo "#################################################"
echo "#                                               #"
echo "             ${TOOL} Provisioner"
echo "#                                               #"
echo "#################################################"
echo ""
}

# Function to set up environment variables
variables ()
{
set -a	# Enable automatic export of variables
ipAddress=$(hostname -I | awk '{print $2}') # Get the second IP address because the first one is the localhost or the private IP address
hostname=$(hostname)
env_dir="${ENV_DIR:-/vagrant_data/.env}"
env_file="${env_dir}/.env"
example_file="${EXAMPLE_FILE:-/vagrant_data/example/.env.example}"
EXAMPLE_REMOTE_FILE="${EXAMPLE_REMOTE_URL:-https://raw.githubusercontent.com/lozaexequiel/provisioner/main/Ansible/example/.env.example}"
log_file="/var/log/provision.log"

    # Logging function
log() {
    echo "$(date) $1: $2" | tee -a "$log_file"
}

# Error handling
handle_error() {
    log "ERROR" "An error occurred. Exiting."
    exit 1
}
trap handle_error ERR

    # Check if .env directory exists
    if [ ! -d "${env_dir}" ]; then
        echo "$(date) INFO: The .env directory does not exist or is not detected"
        echo "$(date) INFO: Creating .env directory in ${env_dir}"
        mkdir -p "${env_dir}"
    fi

    # Check if .env file exists and is not empty
    if [ -f "${env_file}" ] && [ -s "${env_file}" ]; then
        echo "Sourcing environment variables from file"
        source "${env_file}"
        # Validate required variables
        if [ -z "${PACKAGES}" ] || [ -z "${SSH_DIR}" ] || [ -z "${PRIVATE_KEY_FILE}" ]; then
            echo "$(date) ERROR: Required environment variables are missing"
            exit 1
        fi
    else
        echo "$(date) INFO: The .env file does not exist, is not detected, or the file is empty"

        # Check if example file exists
        if [ -f "${example_file}" ]; then
            echo "$(date) INFO: Example file detected, creating .env file from example"
            cp "${example_file}" "${env_file}"
        else
            echo "$(date) WARNING: Example file not detected. Downloading from remote location"
            curl -L ${EXAMPLE_REMOTE_FILE} -o ${env_file}
            if [ -s "${env_file}" ]; then
                echo "INFO: Example file downloaded successfully"
                source "${env_file}"      
            else
                echo "$(date) ERROR: ${EXAMPLE_REMOTE_FILE} does not exist or failed to download"
                echo "$(date) ERROR: Failed to download the example file. Please check the URL or your network connection"       
                exit 1
            fi
        fi

        if [ ! -s "${env_file}" ]; then
            echo "$(date) ERROR: The .env file is empty, please fill in the required variables or download the example file"
            exit 1
        fi
    fi

    # Disable automatic export of variables
    set +a
}

disable_swap ()
{
  sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
  swapoff -a
  if [ $? -ne 0 ]; then
    echo "$(date) ERROR: Failed to disable swap"
    exit 1
  fi
}

# Function to install dependencies
install_dependencies ()
{
  apt-get update
  if [ $? -ne 0 ]; then
    echo "$(date) ERROR: Failed to update package list"
    exit 1
  fi

  apt-get install --yes ${PACKAGES}
  if [ $? -ne 0 ]; then
    echo "$(date) ERROR: Failed to install packages"
    exit 1
  fi

  echo "$(date) INFO: Dependencies installed, continuing with the installation in ${hostname}"
}

clean_up ()
{
  apt-get autoremove --yes
  if [ $? -ne 0 ]; then
    echo "$(date) ERROR: Failed to remove unnecessary packages"
    exit 1
  fi

  apt-get clean
  if [ $? -ne 0 ]; then
    echo "$(date) ERROR: Failed to clean up package lists"
    exit 1
  fi

  rm -rf /vagrant_data/functions.sh
  if [ $? -ne 0 ]; then
    echo "$(date) ERROR: Failed to remove functions.sh"
    exit 1
  fi
}

# Create a new SSH key in the local path
create_ssh_key ()
{
  mkdir -p ${SSH_DIR}
  cd ${SSH_DIR}

  ssh-keygen -t rsa -b 4096 -C "${USER}@${hostname}" -f ${PRIVATE_KEY_FILE} -N ""
  if [ $? -ne 0 ]; then
    echo "$(date) ERROR: Failed to generate SSH key"
    exit 1
  fi

  chown -R ${USER}:${USER} ${SSH_DIR}
  eval "$(ssh-agent -s)"
  ssh-add ${PRIVATE_KEY_FILE}
}

permission_ssh_key ()
{
  chmod 700 ${SSH_DIR}
  if [ $? -ne 0 ]; then
    echo "$(date) ERROR: Failed to change permissions of ${SSH_DIR}"
    exit 1
  fi

  chmod 600 ${HOME}/.ssh/authorized_keys
  if [ $? -ne 0 ]; then
    echo "$(date) ERROR: Failed to change permissions of authorized_keys"
    exit 1
  fi

  chown -R ${USER}:${USER} ${SSH_DIR}
  if [ $? -ne 0 ]; then
    echo "$(date) ERROR: Failed to change owner of ${SSH_DIR}"
    exit 1
  fi
}