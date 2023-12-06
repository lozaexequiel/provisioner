# Mosquitto MQTT dev environment

## Prerequisites

This repository needs the following tools to work:

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [Docker](https://www.docker.com/)
- [Docker compose](https://docs.docker.com/compose/)

To start the environment, run the following command:

```vagrant up```

This will start a virtual machine with Mosquitto installed and configured.

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
