# Ansible Provisioner

This directory contains the configuration files for Ansible provisioner.

## Table of Contents

- [Ansible Provisioner](#ansible-provisioner)
	- [Table of Contents](#table-of-contents)
	- [Prerequisites](#prerequisites)
	- [Project Structure](#project-structure)
	- [Variables](#variables)
		- [Global Variables](#global-variables)
		- [Ansible variables](#ansible-variables)
		- [Ansible version](#ansible-version)
	- [Functions](#functions)
	- [Ansible documentation](#ansible-documentation)

## Prerequisites

To use this project you need to have the following software installed:

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

## Project Structure

The basic structure of the project is as follows:

![Architecture](./images/ansible-architecture.svg)

The files and directories are:

~~~bash
./vagrant_data
├── /.env # Environment directory
├── ├── /.env # Environment file
├── ├── /.ansible # Ansible directory
├── ├── ├── /.ansible.cfg # Ansible configuration file
├── ├── ├── /.inventory # Ansible inventory file
├── ├── ├── /.tmp # Temporary directory
├── ├── ├── ├── /ansible-${USER} # Remote temporary
├── ├── ├── ├── /roles # Roles directory
~~~

## Variables

### [Global Variables](../../README.md#global-variables)

Common variables for all provisioners.

### Ansible variables

| Variable name | Description | Default value |
| --- | --- | --- |
| INVENTORY_FILE | Ansible inventory file | /vagrant_data/.env/.ansible/.inventory |
| ANSIBLE_DIR | Ansible directory | /home/vagrant |
| ANSIBLE_PLAYBOOK | Ansible playbook | /vagrant_data/ansible/PLAYBOOK/playbook.yml |
| ANSIBLE_PATH | Ansible path | /vagrant_data/.env/.ansible |
| ANSIBLE_CONFIG | Ansible configuration file | /vagrant_data/.env/.ansible/.ansible.cfg |
| PRIVATE_KEY_FILE | Private key file | /home/vagrant/.ssh/mykey |
| REMOTE_TMP | Remote temporary directory | /vagrant_data/.env/.ansible/.tmp/ansible-${USER} |
| BECOME_USER | Become user | root |
| ROLES_PATH | Roles path | /vagrant_data/.env/.ansible/.tmp/roles |

### Ansible version

If you want an specific version of Ansible you can change the following variable in the environment file:

```ANSIBLE_VERSION=<version>```

Default playbooks path is `/vagrant_data/playbooks` but you can change it in the environment file.

## [Functions](../../README.md#functions)

## Ansible documentation

The Ansible full documentation can be found in [Ansible website](https://docs.ansible.com/ansible/latest/index.html)

[Back to top](#ansible-provisioner)

[Back to Home repository](../../README.md)
