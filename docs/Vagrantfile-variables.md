# Vagrantfile variables

This section contains the default or global variables for the Vagrantfile used in this project.
Please note that the variables can be modified in the `Vagrantfile`.

| Variable name | Description | Default value |
| --- | --- | --- |
| NETWORK | Network type. | public_network |
| INTERFACE | Network interface. This must be the same as the host-only network interface. | enp0s8 |
| IP | Network block address. | 192.168.0 |
| MASTER_COUNT | Number of master nodes. | 1 |
| MASTER_CPU_COUNT | Number of CPUs for the master node. | 2 |
| MASTER_MEMORY | Memory for the master node. | 4096 |
| NODE_COUNT | Number of worker nodes. | 1 |
| NODE_CPU_COUNT | Number of CPUs for the worker node. | 2 |
| NODE_MEMORY | Memory for the worker node. | 4096 |
| ANSIBLE_MEMORY | Memory for the ansible node. | 4096 |
| ANSIBLE_CPU_COUNT | Number of CPUs for the ansible node. | 2 |
| PROVIDER | Provider to use. | virtualbox |
| SCRIPT_FILE | Provision script file. | provision.sh |
| TEST_SCRIPT_FILE | Test script file. | testAnsibleConnection.sh |
| TEST_SCRIPT | Test script URL. | [Test script](https://raw.githubusercontent.com/lozaexequiel/provisioner/main/Ansible/testAnsibleConnection.sh) |
| PROVISION_SCRIPT | Provision script URL. | [Provision script](https://raw.githubusercontent.com/lozaexequiel/provisioner/main/Ansible/provision.sh) |
| BOX | SO image to use. | ubuntu/focal64 |
| VAGRANT_PATH | Host shared folder mounted in /vagrant_path. | /vagrant_data |

## [Go Back](../README.md)
