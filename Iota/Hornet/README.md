# Iota hornet Provisioner

## Table of Contents

- [Iota hornet Provisioner](#iota-hornet-provisioner)
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
- [Github Account](https://www.github.com/)

The project folder structure is as follows:

~~~bash
./

├── .env
│   ├── .iota
│   │   ├── config
│   │   └── credentials
│   └── .env
├── .gitignore
├── README.md
├── Vagrantfile

~~~

If you don't have the .env folder, you can create it by running the following command:

~~~bash
mkdir .env && cd .env && mkdir .aws && touch .env && touch .aws/config && touch .aws/credentials
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

The tools are installed in the virtual machine, not in the host machine.

## Errors

Common issues can be found in the error [folder](./errors/README.md).

---

## Author

Exequiel Loza - [web.lozaexequiel.com](https://web.lozaexequiel.com)

For more information on my projects, please visit my [GitHub profile](https://github.com/lozaexequiel).

[Back to top](#iota-hornet-provisioner)
