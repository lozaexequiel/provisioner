# Ansible Provisioner

## Prerequisites

This repository needs the following tools to work:

- [Ubuntu](https://ubuntu.com/)
- [Ansible](https://www.ansible.com/)
  
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