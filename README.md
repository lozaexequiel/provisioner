# Provisioner

This directory contains the configuration files for the provisioner. The provisioner is responsible for creating the infrastructure and installing the software on the infrastructure. The provisioner can use the following tools:
[Vagrant](https://www.vagrantup.com/), [Ansible](https://www.ansible.com/), [Docker](https://www.docker.com/), [Terraform](https://www.terraform.io/), [Packer](https://www.packer.io/), [AWS CLI](https://aws.amazon.com/cli/)

## Prerequisites

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [AWS Account](https://aws.amazon.com/)
- [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) (to create the AWS resources)

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

If you don't have the .env folder, you can create it by running the following command:

~~~bash
mkdir .env && cd .env && mkdir .aws && touch .env && touch .aws/config && touch .aws/credentials
~~~

## Vagrantfile

Each vagrantfile will download the provisioning scripts from this repository. The provisioning scripts will install the selected software on the virtual machine. The provisioning scripts are written in [bash](https://www.gnu.org/software/bash/).

## Tools in for this project

- [Jenkins](./Jenkins/README.md)
- [Vault](./Vault/README.md)

## Errors

Common issues can be found in the error [folder](./errors/README.md).
