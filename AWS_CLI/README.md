# AWS CLI Provisioner

## Table of Contents

	- [Table of Contents](#table-of-contents)
	- [Prerequisites](#prerequisites)
	- [Variables](#variables)
		- [Global Variables](#global-variables)
		- [AWS\_CLI variables](#aws_cli-variables)
	- [AWS CLI documentation](#aws-cli-documentation)

## Prerequisites

This repository needs the following tools to work:

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [AWS Account](https://aws.amazon.com/)
- [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) (to create the AWS resources)
- [AWS CLI](https://aws.amazon.com/cli/)

you must define the following variables in the .env/.env file:

```bash
AWS_CONFIG_FILE=/vagrant_data/.env/.aws/config
AWS_SHARED_CREDENTIALS_FILE=/vagrant_data/.env/.aws/credentials
```

and load the config and credentials files in the .env/.aws directory:

this is an example of the config file for the AWS CLI:

```bash
[default]
region = us-east-1
output = json
```

this is an example of the credentials file for the AWS CLI:

```bash
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
```

To automatic configuration both files must be loaded in the .env/.aws directory before executing the provision script.

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

### AWS_CLI variables

This sections contains the default or global variables used in the AWS_CLI scripts, and the documentation for the scripts.

| Variable name | Description | Default value |
| --- | --- | --- |
| AWS_CONFIG_FILE | Aws cli config file | /vagrant_data/.env/.aws/config |
| AWS_SHARED_CREDENTIALS_FILE | Aws cli credentials file | /vagrant_data/.env/.aws/credentials |

## AWS CLI documentation

The AWS CLI full documentation can be found in [AWS CLI website](https://aws.amazon.com/cli/)

[Back to top](#ansible-provisioner)

[Back to Home repository](../README.md)