# Blockchain dev environment

## Table of contents

- [Blockchain dev environment](#blockchain-dev-environment)
	- [Table of contents](#table-of-contents)
	- [Prerequisites](#prerequisites)
	- [Development environment](#development-environment)
	- [Installation](#installation)
		- [Accessing blockchain dev environment](#accessing-blockchain-dev-environment)
		- [Manual installation](#manual-installation)
	- [Variables](#variables)
		- [Global Variables](#global-variables)
		- [Blockchain variables](#blockchain-variables)
	- [Blockchain dev environment documentation](#blockchain-dev-environment-documentation)

## Prerequisites

This repository needs the following tools to work:

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [Docker](https://www.docker.com/)
- [Docker compose](https://docs.docker.com/compose/)
- [Quorum network](https://consensys.net/quorum/)
- [Nodejs v10+](https://nodejs.org/en/)

## Development environment

## Installation

To start the environment, run the following command:

```vagrant up```

This will start a virtual machine with blockchain dev environment.

### Accessing blockchain dev environment

To access the virtual machine, run the following command:

```vagrant ssh```

### Manual installation

To start the manual installation, run the following command and follow the instructions:

```npx quorum-dev-quickstart```

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

### Blockchain variables

This sections contains the default or global variables used in the BLOCKCHAIN scripts, and the documentation for the scripts.

| Variable name | Description | Default value |
| --- | --- | --- |
| DOCKER_IMAGE | Docker image | quorumengineering/quorum |
| DOCKER_TAG | Docker tag | 2.2.3 |
| CONSENSUS | Consensus | qbft |
| NODE_MAJOR | Node major | 20 |
| GOREL | Go release | go1.9.3.linux-amd64.tar.gz |
| COMPOSE_PATH | Compose path | ./quorum-examples |

## Blockchain dev environment documentation

- [Consensys blockchain solutions](https://consensys.net/docs/) - Consensys blockchain solutions documentation

[Back to top](#blockchain-dev-environment)

[Back to Home repository](../README.md)