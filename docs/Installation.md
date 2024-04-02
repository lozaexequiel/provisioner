# Installation

This document provides step-by-step instructions on how to install and set up the project on your local machine for development and testing purposes.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have a Windows machine. The instructions are specific to this operating system.
- You have installed the latest version of [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
- You have installed [Vagrant](https://www.vagrantup.com/docs/installation) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (or any other virtualization software compatible with Vagrant).

## Installing the Project

To install the project, follow these steps:

1. Clone the repository to your local machine:

~~~bash
git clone https://github.com/lozaexequiel/provisioner.git
~~~

2. Navigate to the project directory:

~~~bash
cd provisioner
~~~

3. Navigate to the tool you want to install:

~~~bash
cd vagrant_data/<TOOL>
~~~

4. Run the following command to install the tool in the virtual machine:

~~~bash
vagrant up
~~~
