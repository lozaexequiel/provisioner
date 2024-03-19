# Provisioner

## Table of Contents

- [Provisioner](#provisioner)
	- [Table of Contents](#table-of-contents)
	- [Prerequisites](#prerequisites)
	- [Vagrantfile](#vagrantfile)
	- [Tools in for this project](#tools-in-for-this-project)
	- [Access the shared folder](#access-the-shared-folder)
	- [Installing the tools](#installing-the-tools)
	- [Warning](#warning)
	- [Errors](#errors)
	- [Author](#author)

This directory contains the configuration files for provision tools.

## Prerequisites

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

The project folder structure is as follows:

~~~bash
./

├── .env
│   ├── .aws
│   │   ├── config
│   │   └── credentials
│   └── .env
├── .gitignore
├── README.md
├── Vagrantfile

~~~

## Vagrantfile

Each vagrantfile will download the provisioning scripts from this repository. The provisioning scripts will install the selected software on the virtual machine. The provisioning scripts are written in [bash](https://www.gnu.org/software/bash/).

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

## Access the shared folder

To access the shared folder, run the following command:

```cd /vagrant_data```

## Installing the tools

To install the tools in the virtual machine you can run the following command:

```sudo sh /vagrant_data/<TOOL>/provision.sh```

Please read the README.md of each tool to know how to configure it.

**If you want to use the scripts from the local folder, comment the remote scripts and uncomment the local scripts. Check if the local scripts are in the same folder as the Vagrantfile.**

## Warning

The tools are installed in the virtual machine, not in the host machine please check the virtual machine IP address to access the installed tools. The virtual machine IP address is shown in the terminal after running the `vagrant up` command.

## Errors

Common issues can be found in the error [folder](./errors/README.md).

---

## Author

Exequiel Loza - [web.lozaexequiel.com](https://web.lozaexequiel.com)

For more information on my projects, please visit my [GitHub profile](https://github.com/lozaexequiel).

[Back to top](#provisioner)
