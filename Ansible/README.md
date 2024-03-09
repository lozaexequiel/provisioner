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
| PACKAGES | Packages to install | docker.io ansible unzip python3-pip docker-compose git |
| ENV_FILE | Environment file | /vagrant_data/.env/.env |
| ENV_PATH | Environment path | /vagrant_data/.env |

---

### Ansible variables

This sections contains the default or global variables used in the Ansible scripts, and the documentation for the scripts.

| Variable name | Description | Default value |
| --- | --- | --- |
| INVENTORY_DIR | Ansible inventory directory | /vagrant_data/ansible/INVENTORY |
| ANSIBLE_DIR | Ansible directory | /vagrant_data/ansible |
| ANSIBLE_PLAYBOOK | Ansible playbook | /vagrant_data/ansible/PLAYBOOK/playbook.yml |

---

## Ansible dev environment

If you want an specific version of Ansible you must define the next variable in the .env/.env file:

```bash
ANSIBLE_VERSION="2.9.6"
```

Default playbooks path is `/vagrant_data/ansible/PLAYBOOK/` but you can change it in the .env/.env file:

```bash

---
I have a playbook that looks like this:

```yaml
---
- hosts: localhost
  tasks:
    - name: Install Docker
      apt:
 name: docker.io
 state: present
 update_cache: yes
    - name: Install Docker Python Module
      pip:
 name: docker
 state: present
    - name: Download and launch a docker web container
      docker_container:
 name: web
 image: nginx
 state: started
 ports:
   - "80:80"
```

To run the playbook, use the following command:

```bash
ansible-playbook -i inventory playbook.yml
```

The output should look like this:

```bash
PLAY [localhost] ************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Install Docker] ********************************************************************************************************************************************************************************************************************************************************

TASK [Install Docker Python Module] *****************************************************************************************************************************************************************************************************************************************

TASK [Download and launch a docker web container] ****************************************************************************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP *******************************************************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

To check if the container is running, use the following command:

```bash
docker ps
```

## Ansible documentation

The Ansible full documentation can be found in [Ansible website](https://docs.ansible.com/ansible/latest/index.html)

---

[Back to top](#ansible-provisioner)

[Back to Home repository](../README.md)
