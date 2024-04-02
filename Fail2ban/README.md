# Fail2ban Provisioner

This directory contains the configuration files for Fail2ban provisioner.

## Table of Contents

- [Fail2ban Provisioner](#fail2ban-provisioner)
	- [Table of Contents](#table-of-contents)
	- [Prerequisites](#prerequisites)
	- [Project Structure](#project-structure)
	- [Variables](#variables)
		- [Global Variables](#global-variables)
		- [fail2ban variables](#fail2ban-variables)
		- [Fail2ban version](#fail2ban-version)
	- [Fail2ban documentation](#fail2ban-documentation)

## Prerequisites

To use this project you need to have the following software installed:

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

## Project Structure

The basic structure of the project is as follows:

![Architecture](./docs/images/arc.svg)

The files and directories are:

~~~bash
./vagrant_data
├── /.env # Environment directory
├── ├── /.env # Environment file
├── ├── /.fail2ban # Fail2ban directory
├── ├── ├── /.jail.local # Fail2ban jail configuration file
~~~

## Variables

### [Global Variables](../README.md#global-variables)

Common variables for all provisioners.

### fail2ban variables

| Variable name | Description | Default value |
| --- | --- | --- |
| `fail2ban_version` | Fail2ban version | `0.11.2` |

### Fail2ban version

To display the Fail2ban version, you can use the following command:

~~~bash
fail2ban-client -V
~~~

## Fail2ban documentation

The Fail2ban documentation can be found [here](https://www.fail2ban.org/wiki/index.php/Main_Page).

---

[Back to top](#fail2ban-provisioner) |

[Back to Home repository](../README.md)
