# -*- mode: ruby -*-
# vi: set ft=ruby :
BOX="ubuntu/lunar64"
SCRIPT_REPOSITORY = "https://github.com/lozaexequiel/provisioner.git"
provisioner = "provisioner"
VAGRANT_PATH = "/vagrant_data"
ENV_PATH = "/vagrant_data/.env"
PROVISION_SCRIPT = "Vault/provision.sh"
PROVIDER       = "virtualbox"
# Define master resources
MASTER_MEMORY   = "4096"
NODE_MEMORY     = "4096"
MASTER_CPU_COUNT = "2"
# Define node resources
MASTER_IP       = "192.168.0.30"
NODE_01_IP       = "192.168.0.34"
NODE_MEMORY   = "4096"
NODE_CPU_COUNT = "2"
#NODE_02_IP      = "172.1.8.45"
#NODE_02_IP      = "172.1.8.46"
#NODE_03_IP      = "172.1.8.47"
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
	    box.vm.provision "shell", inline: "echo 'provisioning' #{box.vm.hostname} ..."
	    box.vm.provision "shell", path: "scripts/provision.sh"
	  if box.vm.hostname =~ /master/ then
	    box.vm.provision "shell", inline: "sudo rm -rf #{VAGRANT_PATH}/provisioner"
	    box.vm.provision "shell", inline: "curl -sSLf https://raw.githubusercontent.com/lozaexequiel/provisioner/main/Vault/provision.sh | sudo sh"
	    #box.vm.provision "shell", inline: "sudo chmod +x #{VAGRANT_PATH}/provisioner/#{PROVISION_SCRIPT}"
	    #box.vm.provision "shell", path: "provisioner/#{PROVISION_SCRIPT}"	    
	    box.vm.provision "shell", inline: "echo 'provisioning' #{box.vm.hostname} ... done"
	end
	  
	  if box.vm.hostname =~ /node/ then
		box.vm.provision "shell", inline: "echo 'provisioning' #{box.vm.hostname} ..."
		box.vm.provision "shell", inline: "echo 'No provisioner for nodes' && exit 0"
	end
end
end
end