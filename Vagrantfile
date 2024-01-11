# -*- mode: ruby -*-
# vi: set ft=ruby :

# simple vagrant to test the config
Vagrant.configure("2") do |config|
  config.vm.define "debian" do |debian|
    debian.vm.box = "debian/bookworm64"
    # debian.vm.network "private_network", ip: "192.168.56.10"
    debian.vm.hostname =  "debian"
    debian.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "deploy.yaml"
      ansible.verbose = true
      ansible.galaxy_role_file = "requirements.yml"
      # ansible.galaxy_command = "ansible-galaxy collection install -r %{role_file} && ansible-galaxy role install -r %{role_file}"
      # ansible.galaxy_command = "ansible-galaxy collection install -r %{role_file}"
    end
    debian.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
    end
  end
end
