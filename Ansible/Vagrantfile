# -*- mode: ruby -*-
# vi: set ft=ruby :
BOX="ubuntu/jammy64"
PROVISION_SCRIPT="https://raw.githubusercontent.com/lozaexequiel/provisioner/main/Ansible/provision.sh"
SCRIPT_FILE="provision.sh"
TEST_SCRIPT="https://raw.githubusercontent.com/lozaexequiel/provisioner/main/Ansible/testAnsibleConnection.sh"
TEST_SCRIPT_FILE="testAnsibleConnection.sh"
# Shared folder configuration
VAGRANT_PATH="/vagrant_data"
# Provider configuration
PROVIDER="virtualbox"
# Network configuration
IP="192.168.0"
NETWORK="public_network"
INTERFACE="Realtek Gaming GbE Family Controller"
# Define ansible resources
ANSIBLE_MEMORY="4096"
ANSIBLE_CPU_COUNT="2"
# Define master resources
MASTER_COUNT=1
MASTER_MEMORY="4096"
MASTER_CPU_COUNT="2"
# Define node resources
NODE_COUNT=1
NODE_MEMORY="4096"
NODE_CPU_COUNT="2"
# Define Vagrant configuration
Vagrant.configure("2") do |config|
	config.vm.box = BOX
	if MASTER_COUNT < 1 and NODE_COUNT < 1 then
	  puts "MASTER_COUNT and NODE_COUNT must be greater than 0"
	  exit 1
	end
	boxes = []
	boxes << { :name => "ansible", :ip => "#{IP}.10", :cpus => ANSIBLE_CPU_COUNT, :memory => ANSIBLE_MEMORY, :network => NETWORK, :bridge => INTERFACE }	
	(1..MASTER_COUNT).each do |i|
		boxes << { :name => "master-#{i}", :ip => "#{IP}.#{i+10}", :cpus => MASTER_CPU_COUNT, :memory => MASTER_MEMORY, :network => NETWORK, :bridge => INTERFACE }
	      end
	      (1..NODE_COUNT).each do |i|
		boxes << { :name => "node-#{i}", :ip => "#{IP}.#{i+20}", :cpus => NODE_CPU_COUNT, :memory => NODE_MEMORY, :network => NETWORK, :bridge => INTERFACE }
	      end
	boxes.each_with_index do |opts, index|
		config.vm.define opts[:name] do |box|
			box.vm.synced_folder ".", VAGRANT_PATH
			box.vm.hostname = opts[:name]
			box.vm.network opts[:network], bridge: opts[:bridge], ip: opts[:ip]
			box.vm.provider PROVIDER do |vb|
				vb.cpus = opts[:cpus]
				vb.memory = opts[:memory]
			end
			box.vm.provision "shell", inline: <<-SHELL
				if [ ! -f #{VAGRANT_PATH}/#{SCRIPT_FILE} ]; then
					echo "WARNING: #{SCRIPT_FILE} not found, trying to download it from the repository"
					curl -s #{PROVISION_SCRIPT} -o #{VAGRANT_PATH}/#{SCRIPT_FILE}
					chmod +x #{VAGRANT_PATH}/#{SCRIPT_FILE}
				fi
				cd #{VAGRANT_PATH} && ./#{SCRIPT_FILE}
			SHELL
			if index == boxes.length - 1 then
				box.vm.provision "shell", inline: <<-SHELL
					if [ ! -f #{VAGRANT_PATH}/#{TEST_SCRIPT_FILE} ]; then
						echo "WARNING: #{TEST_SCRIPT_FILE} not found, trying to download it from the repository"
						curl -s #{TEST_SCRIPT} -o #{VAGRANT_PATH}/#{TEST_SCRIPT_FILE} && chmod +x #{VAGRANT_PATH}/#{TEST_SCRIPT_FILE}
					fi
					echo "INFO: You can now ssh into the ansible box with: [ vagrant ssh ansible ]"
					echo "INFO: You can check the ansible connection with: [ vagrant ssh ansible -c 'cd #{VAGRANT_PATH} && ./#{TEST_SCRIPT_FILE}' ]"
				SHELL
			end
		end
	end
end