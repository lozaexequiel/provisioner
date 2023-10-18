# AWS CLI Provisioner

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

Both files are loaded in the .env/.aws directory.

## AWS CLI documentation

The AWS CLI full documentation can be found in [AWS CLI website](https://aws.amazon.com/cli/)