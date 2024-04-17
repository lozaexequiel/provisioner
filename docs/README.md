# Provisioner

This project is a collection of provisioning scripts for different tools. The provisioning scripts are written in [bash](https://www.gnu.org/software/bash/). The provisioning scripts are used to install the selected software on the virtual machine.
The virtual machine is created using [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).

## Table of Contents

- [Provisioner](#provisioner)
	- [Table of Contents](#table-of-contents)
	- [Prerequisites](#prerequisites)
	- [Project Structure](#project-structure)
	- [Tools in for this project](#tools-in-for-this-project)
	- [Vagrantfile](#vagrantfile)
	- [Install](#install)
		- [Global Variables](#global-variables)
		- [Vagrantfile variables](#vagrantfile-variables)
		- [Access the shared folder](#access-the-shared-folder)
		- [Attention](#attention)
		- [Errors](#errors)
	- [Author](#author)

This directory contains the configuration files for provision tools.

## Prerequisites

To use this project you need to have the following software installed:

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

## Project Structure

The basic structure of the project is as follows:

~~~bash
./vagrant_data
├── /.env # Environment directory
├── ├── /.env # Environment file
├── ├── /<TOOL> # Tool directory
~~~

The `vagrant_data` directory is mounted in the virtual machine as `/vagrant_data`. The `vagrant_data` directory contains the provisioning scripts for the tools and the environment directory.

## Tools in for this project

This project contains the following tools for provisioning:

- [Ansible](./Ansible/docs/README.md)
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

## Vagrantfile

Each vagrantfile will download the provisioning scripts from this repository. The provisioning scripts will install the selected software on the virtual machine and the shared folder will be mounted in the virtual machine as `/vagrant_data`.

## Install

First, you need to clone the repository:

```git clone https://github.com/lozaexequiel/provisioner.git```

Then access to the repository:

```cd provisioner```

After that, you can access the tool you want to install:

```cd vagrant_data/<TOOL>```

To install the tools in the virtual machine you can run the following command:

```vagrant up```

### Global Variables

This section contains the default or global variables used in the scripts.

| Variable name | Description | Default value |
| --- | --- | --- |
| USER | User name | vagrant |
| HOME | User home | /home/vagrant |
| PACKAGES | Packages to install | ansible unzip python3-pip git |
| VAGRANT_PATH | Vagrant path | /vagrant_data |

To install the tools in the virtual machine you can run the following command:

```vagrant up```

After running the command, the tools will be installed in the virtual machine.
You can access the virtual machine by running the following command:

```vagrant ssh <VM_NAME>```

### [Vagrantfile variables](./docs/Vagrantfile-variables.md)

The list of variables used in the Vagrantfile can be found in the docs folder. Please read the [Vagrantfile variables](./docs/Vagrantfile-variables.md) for more information.

### Access the shared folder

By default, the shared folder is located in the following path:

```cd /vagrant_data```

To manually install the tools run the following command:

```vagrant ssh <VM_NAME>```

```cd /vagrant_data```

```sudo sh /vagrant_data/<TOOL>/provision.sh```

*Please read the README.md of each tool to know how to configure it.*

### Attention

The tools are installed in the virtual machine, not in the host machine please check the virtual machine IP address to access the installed tools. The virtual machine IP address is shown in the terminal after running the `vagrant up` command.

### Errors

Common issues can be found in the error [folder](./errors/README.md).

## Author

Exequiel Loza - [web.lozaexequiel.com](https://web.lozaexequiel.com)

For more information on my projects, please visit my [GitHub profile](https://github.com/lozaexequiel).

[Back to top](#provisioner)
