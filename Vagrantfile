# -*- mode: ruby -*-
# vi: set ft=ruby :
BOX="ubuntu/lunar64"
SCRIPT_REPOSITORY = "https://raw.githubusercontent.com/lozaexequiel/provisioner/main/provision.sh"
DOCKER="https://raw.githubusercontent.com/lozaexequiel/provisioner/main/Docker/provision.sh"
VAGRANT_PATH = "/vagrant_data"
PROVIDER       = "virtualbox"
# Define master resources
MASTER_MEMORY   = "4096"
MASTER_CPU_COUNT = "2"
MASTER_IP       = "192.168.0.130"
# Define node resources
NODE_MEMORY   = "4096"
NODE_CPU_COUNT = "2"
NODE_01_IP       = "192.168.0.34"
# Define Vagrant configuration
Vagrant.configure("2") do |config|
	config.vm.box = BOX
	boxes = [
	  { :name => "master-01", :ip => MASTER_IP, :cpus => MASTER_CPU_COUNT, :memory => MASTER_MEMORY },
	 # { :name => "node-02", :ip => NODE_02_IP, :cpus => CPU_COUNT, :memory => NODE_MEMORY },
	]
	boxes.each do |opts|
	  config.vm.define opts[:name] do |box|
	    box.vm.synced_folder ".", VAGRANT_PATH
	    box.vm.hostname = opts[:name]
	    box.vm.network :public_network, ip: opts[:ip]
	    box.vm.provider PROVIDER do |vb|
	      vb.cpus = opts[:cpus]
	      vb.memory = opts[:memory]
	    end
	  if box.vm.hostname =~ /master/ then
	    box.vm.provision "shell", inline: "curl -sSLf #{SCRIPT_REPOSITORY} | sudo sh"	
	    box.vm.provision "shell", inline: "echo 'provisioning' #{box.vm.hostname} ... done"
	end
	  
	  if box.vm.hostname =~ /node/ then
		box.vm.provision "shell", inline: "echo 'provisioning' #{box.vm.hostname} ..."
		box.vm.provision "shell", inline: "echo 'No provisioner for nodes' && exit 0"
	end
end
end
end