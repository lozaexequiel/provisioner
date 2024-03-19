# Ansible Provisioner

## Table of Contents

- [Home repository](../README.md)
- [Ansible Provisioner](#ansible-provisioner)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Variables](#variables)
- [Global Variables](#global-variables)
- [Ansible variables](#ansible-variables)
- [Ansible documentation](#ansible-documentation)

## Prerequisites

This repository needs the following tools to work:

- [Ubuntu](https://ubuntu.com/)
- [Ansible](https://www.ansible.com/)

## Variables

### Global Variables

This section contains the default or global variables used in the scripts.

| Variable name | Description | Default value |
| --- | --- | --- |
| USER | User name | vagrant |
| HOME | User home | /home/vagrant |
| PACKAGES | Packages to install | ansible unzip python3-pip git |
| ENV_FILE | Environment file | /vagrant_data/.env/.env |
| ENV_PATH | Environment path | /vagrant_data/.env |

---

### Ansible variables

This sections contains the default or global variables used in the Ansible scripts, and the documentation for the scripts.

| Variable name | Description | Default value |
| --- | --- | --- |
| INVENTORY_FILE | Ansible inventory file | /vagrant_data/.env/.ansible/.inventory |
| ANSIBLE_DIR | Ansible directory | /home/vagrant |
| ANSIBLE_PLAYBOOK | Ansible playbook | /vagrant_data/ansible/PLAYBOOK/playbook.yml |
| ANSIBLE_PATH | Ansible path | /vagrant_data/.env/.ansible |
| ANSIBLE_CONFIG | Ansible configuration file | /vagrant_data/.env/.ansible/.ansible.cfg |
| PRIVATE_KEY_FILE | Private key file | /home/vagrant/.ssh/mykey |

---

## Ansible dev environment

If you want an specific version of Ansible you must define the next variable in the .env/.env file:

`ANSIBLE_VERSION="2.9.6"`

Default playbooks path is `/vagrant_data/ansible/PLAYBOOK/` but you can change it in the .env/.env file:

## Ansible documentation

The Ansible full documentation can be found in [Ansible website](https://docs.ansible.com/ansible/latest/index.html)

---

[Back to top](#ansible-provisioner)

[Back to Home repository](../README.md)
