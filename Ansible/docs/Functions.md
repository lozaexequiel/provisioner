# Functions

This document provides information about the functions used in the project.

The ansible provision script has the following functions:

provision - This function is the main function that calls all the other functions in the script and downloads the necessary files.
variables - This function sets the variables for the script.
header - This function prints the header of the script.
disable_swap - This function disables the swap.
install_dependencies - This function installs the dependencies, packages to install with apt-get.
ansible_provision - This function installs ansible.
ansible_ssh_key - This function creates the ssh key for ansible and register it in the authorized_keys server file.
ansible_config - This function creates the ansible configuration file.
ansible_inventory - This function creates the ansible inventory file with the provisioned servers.
permission_ssh_key - This function sets the permissions for the ssh key.
ansible_create_vars - This function creates the variables file for ansible.
clean_up - This function removes the unnecessary files.
