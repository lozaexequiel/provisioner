# NordVPN provisioner

This directory contains the configuration files for provision tools.

## Table of contents

- [NordVPN provisioner](#nordvpn-provisioner)
	- [Table of contents](#table-of-contents)
	- [Prerequisites](#prerequisites)
	- [Vagrantfile](#vagrantfile)
	- [Tools in for this project](#tools-in-for-this-project)
	- [Access the shared folder](#access-the-shared-folder)
	- [Warning](#warning)
	- [Variables](#variables)
		- [Global Variables](#global-variables)
		- [NordVPN variables](#nordvpn-variables)
	- [NordVPN documentation](#nordvpn-documentation)

---

## Prerequisites

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [NordVPN account](https://nordvpn.com/)

The project folder structure is as follows:

~~~bash
./

├── .env
│   └── .env
├── .gitignore
├── README.md
├── Vagrantfile

~~~

If you don't have the .env folder, you can create it by running the following command:

~~~bash
mkdir .env && cd .env && mkdir .aws && touch .env && touch .aws/config && touch .aws/credentials
~~~

---

## Vagrantfile

Each vagrantfile will download the provisioning scripts from this repository. The provisioning scripts will install the selected software on the virtual machine. The provisioning scripts are written in [bash](https://www.gnu.org/software/bash/).

---

## Tools in for this project

- [Ansible](./Ansible/README.md)
- [AWS CLI](./AWS_CLI/README.md)
- [Blockchain](./Blockchain/README.md)
- [Docker](./Docker/README.md)
- [Docker Compose](./Docker/README.md)
- [Git](./Git/README.md)
- [Jenkins](./Jenkins/README.md)
- [Terraform](./Terraform/README.md)
- [Packer](./Packer/README.md)
- [Vagrant](./Vagrant/README.md)
- [Vault](./Vault/README.md)

---

## Access the shared folder

To access the shared folder, run the following command:

```cd /vagrant_data```

---

## Warning

The tools are installed in the virtual machine, not in the host machine.

---

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

### NordVPN variables

This section contains the default or global variables used in the scripts.

| Variable name | Description | Default value |
| --- | --- | --- |
| NORDVPN_USER | NordVPN user | |
| NORDVPN_PASS | NordVPN password | |
| NORDVPN_COUNTRY | NordVPN country | |
| NORDVPN_TOKEN | NordVPN token | |

---

## NordVPN documentation

The NordVPN full documentation can be found in [NordVPN website](https://nordvpn.com/)

---

[Back to top](#nordvpn-provisioner)

[Back to Home repository](../README.md)
