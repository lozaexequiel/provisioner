# Mosquitto MQTT dev environment

## Table of Contents

- [Mosquitto MQTT dev environment](#mosquitto-mqtt-dev-environment)
	- [Table of Contents](#table-of-contents)
	- [Prerequisites](#prerequisites)
	- [Variables](#variables)
		- [Global Variables](#global-variables)
		- [Mosquitto MQTT variables](#mosquitto-mqtt-variables)
	- [Accessing Mosquitto MQTT](#accessing-mosquitto-mqtt)
	- [Mosquitto MQTT documentation](#mosquitto-mqtt-documentation)

## Prerequisites

This repository needs the following tools to work:

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [Docker](https://www.docker.com/)
- [Docker compose](https://docs.docker.com/compose/)

To start the environment, run the following command:

```vagrant up```

This will start a virtual machine with Mosquitto installed and configured.

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

### Mosquitto MQTT variables

This sections contains the default or global variables used in the Mosquitto MQTT scripts, and the documentation for the scripts.

| Variable name | Description | Default value |
| --- | --- | --- |
| DOCKER_IMAGE | Docker image | eclipse-mosquitto |
| DOCKER_TAG | Docker tag | latest |

## Accessing Mosquitto MQTT

To set the initial password admin to login in Mosquitto MQTT, in the following file:

```/vagrant_data/.env/.env```

If you not set the default password the provisioning will set the mosquitto.conf file with the default ***NO PASSWORD***. And will allow ***anonymous access***.

mosquitto.conf file:

```bash
listener 1883
allow_anonymous true
```

## Mosquitto MQTT documentation

The Mosquitto full documentation can be found in [Mosquitto website](https://mosquitto.org/)
