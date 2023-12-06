# Blockchain dev environment

## Prerequisites

This repository needs the following tools to work:

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [Docker](https://www.docker.com/)
- [Docker compose](https://docs.docker.com/compose/)
- [Quorum network](https://consensys.net/quorum/)
- [Nodejs v10+](https://nodejs.org/en/)

To start the environment, run the following command:

```vagrant up```

This will start a virtual machine with Mosquitto installed and configured.

## Accessing blockchain dev environment

To access the virtual machine, run the following command:

```vagrant ssh```

## Starting the blockchain dev environment

To start the blockchain dev environment, run the following command:

```npx quorum-dev-quickstart```

## Blockchain dev environment documentation

- [Consensys blockchain solutions](https://consensys.net/docs/) - Consensys blockchain solutions documentation
