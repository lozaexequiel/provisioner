# -*- mode: ruby -*-
# vi: set ft=ruby :
BOX="ubuntu/jammy64"
SCRIPT_REPOSITORY="./provision.sh"
VAGRANT_PATH="/vagrant_data"
PROVIDER="virtualbox"
IP="192.168.0"
NETWORK="public_network"
INTERFACE="Realtek Gaming GbE Family Controller"
# Define master resources
MASTER_COUNT=1
MASTER_MEMORY="8192"
MASTER_CPU_COUNT="4"
# Define node resources
NODE_COUNT=0
NODE_MEMORY="8192"
NODE_CPU_COUNT="4"
# Define Vagrant configuration
Vagrant.configure("2") do |config|
	config.vm.box = BOX
	if MASTER_COUNT < 1 and NODE_COUNT < 1 then
	  puts "MASTER_COUNT and NODE_COUNT must be greater than 0"
	  exit 1
	end
	boxes = []	
	(1..MASTER_COUNT).each do |i|
		boxes << { :name => "master-#{i}", :ip => "#{IP}.#{i+10}", :cpus => MASTER_CPU_COUNT, :memory => MASTER_MEMORY, :network => NETWORK, :bridge => INTERFACE }
	      end
	      (1..NODE_COUNT).each do |i|
		boxes << { :name => "node-#{i}", :ip => "#{IP}.#{i+20}", :cpus => NODE_CPU_COUNT, :memory => NODE_MEMORY, :network => NETWORK, :bridge => INTERFACE }
	      end
	      boxes.each do |opts|
		config.vm.define opts[:name] do |box|
		  box.vm.synced_folder ".", VAGRANT_PATH
		  box.vm.hostname = opts[:name]
		  box.vm.network opts[:network], bridge: opts[:bridge], ip: opts[:ip]
		  box.vm.provider PROVIDER do |vb|
		    vb.cpus = opts[:cpus]
		    vb.memory = opts[:memory]
		  end
		  box.vm.provision "shell", path: SCRIPT_REPOSITORY
	      end
	      end
      end