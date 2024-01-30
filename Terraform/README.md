# Terraform dev environment

## Table of contents

- [Terraform dev environment](#terraform-dev-environment)
	- [Table of contents](#table-of-contents)
	- [Prerequisites](#prerequisites)
	- [Usage](#usage)
	- [Variables](#variables)
		- [Global Variables](#global-variables)
	- [Terraform documentation](#terraform-documentation)

## Prerequisites

- [Git](https://git-scm.com/downloads)
- Vagrant
- VirtualBox
- [Terraform](https://www.terraform.io/downloads.html)

## Usage

To start the environment, run the following command:

```vagrant up```

This will start a virtual machine with Terraform installed.

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

## Terraform documentation

The terraform full documentation can be found in [Terraform website](https://www.terraform.io/docs/index.html)

---

[Back to top](#terraform-dev-environment)

[Back to Home repository](../README.md)