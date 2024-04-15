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
	env_dir="/vagrant_data/.env"
	env_file="${env_dir}/.env"
	example_file="/vagrant_data/example/.env.example"
	EXAMPLE_REMOTE_FILE="https://raw.githubusercontent.com/lozaexequiel/provisioner/main/Ansible/example/.env.example"

	# Check if .env directory exists
	if [ ! -d "${env_dir}" ]; then
		echo "INFO: The .env directory does not exist or is not detected"
		echo "Creating .env directory in ${env_dir}"
		mkdir -p "${env_dir}"
	fi

	# Check if .env file exists and is not empty
	if [ -f "${env_file}" ] && [ -s "${env_file}" ]; then
		echo "Sourcing environment variables from file"
		source "${env_file}"
	else
		echo "INFO: The .env file does not exist, is not detected, or the file is empty"

		# Check if example file exists
		if [ -f "${example_file}" ]; then
			echo "INFO: Example file detected, creating .env file from example"
			cp "${example_file}" "${env_file}"
		else
			echo "WARNING: Example file not detected. Downloading from remote location"
			curl -L ${EXAMPLE_REMOTE_FILE} -o ${env_file}
			if [ -s "${env_file}" ]; then
				echo "INFO: Example file downloaded successfully"
				source "${env_file}"      
			else
				echo "ERROR: ${EXAMPLE_REMOTE_FILE} does not exist or failed to download"
				echo "ERROR: Failed to download the example file. Please check the URL or your network connection"       
				exit 1
			fi
		fi

		if [ ! -s "${env_file}" ]; then
			echo "ERROR: The .env file is empty, please fill in the required variables or download the example file"
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
rm -rf /vagrant_data/functions.sh
}

# Create a new SSH key in the local path
create_ssh_key ()
{
  mkdir -p ${SSH_DIR}      
  cd ${SSH_DIR}
  ssh-keygen -t rsa -b 4096 -C "${USER}@${hostname}" -f ${PRIVATE_KEY_FILE} -N ""
  chown -R ${USER}:${USER} ${SSH_DIR}
  eval "$(ssh-agent -s)"
  ssh-add ${PRIVATE_KEY_FILE}
}

permission_ssh_key ()
{
chmod 700 ${SSH_DIR}
chmod 600 ${HOME}/.ssh/authorized_keys
chown -R ${USER}:${USER} ${SSH_DIR}
}
