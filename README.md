# Provisioner

This directory contains the configuration files for provision tools.

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

- [Vagrant](./Vagrant/README.md)
- [Ansible](./Ansible/README.md)
- [Docker](./Docker/README.md)
- [Terraform](./Terraform/README.md)
- [Packer](./Packer/README.md)
- [AWS CLI](./AWS_CLI/README.md)
- [Jenkins](./Jenkins/README.md)
- [Vault](./Vault/README.md)

## Access the shared folder

To access the shared folder, run the following command:

```cd /vagrant_data```

## Installing the tools

To install the tools in the virtual machine you can run the following command:

```sudo sh /vagrant_data/<TOOL>/provision.sh```

Please read the README.md of each tool to know how to configure it.

## Errors

Common issues can be found in the error [folder](./errors/README.md).
