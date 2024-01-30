# Git Configuration

This repository contains a Vagrantfile to create a virtual machine with Git installed with some default configuration.

## Table of Contents

- [Git Configuration](#git-configuration)
	- [Table of Contents](#table-of-contents)
	- [Prerequisites](#prerequisites)
	- [Usage](#usage)
		- [Clone the repository](#clone-the-repository)
		- [Start the virtual machine](#start-the-virtual-machine)
	- [Variables](#variables)
		- [Global Variables](#global-variables)
		- [Git Variables](#git-variables)
	- [Documentation](#documentation)

## Prerequisites

- [Git](https://git-scm.com/downloads)
- Vagrant
- VirtualBox

## Usage

### Clone the repository

```bash
git clone
```

### Start the virtual machine

```bash
vagrant up
```

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

### Git Variables

This sections contains the default or global variables used in the GIT scripts, and the documentation for the scripts.

| Variable name | Description | Default value |
| --- | --- | --- |
| GIT_USER | Git user | USER |
| GIT_EMAIL | Git email | <email@git.com> |
| EDITOR | Editor | vim |

---

## Documentation

To learn more about the tools used in this repository, please refer to the following documentation:

- [Git](https://git-scm.com/doc)
- [Vagrant](https://www.vagrantup.com/docs)
- [VirtualBox](https://www.virtualbox.org/wiki/Documentation)

---

[Back to top](#git-configuration)

[Back to Home repository](../README.md)