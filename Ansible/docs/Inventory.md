# Inventory

The creation of the inventory file is done by the ansible_inventory function. This function creates an inventory file with sections for "master", "node", and "other" servers. The function adds the current host's information to the appropriate section based on the hostname of the machine.

```ansible_inventory``` function does:

- It checks the hostname of the current machine.
- If the hostname contains "ansible", it checks if the INVENTORY_FILE exists. If it does, it simply prints a message stating that the file already exists. 
- If it doesn't, it creates a new inventory file with sections for "master", "node", and "other", and then prints a message stating that the file has been created.
- If the hostname contains "master", it adds the current host's information to the "master" section of the inventory file.
- If the hostname contains "node", it adds the current host's information to the "node" section of the inventory file.
- If the hostname doesn't contain "ansible", "master", or "node", it prints a warning message and adds the current host's information to the "other" section of the inventory file.
- The host's information includes the hostname, IP address, username, and the path to the SSH private key file. This information is added to the inventory file using the awk command.

You can see the script in the full repository [here](https://github.com/lozaexequiel/provisioner/blob/main/provision.sh).
