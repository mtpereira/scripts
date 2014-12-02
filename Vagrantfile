# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 sw=2 tw=0 et :

vmname = File.basename(File.expand_path(File.dirname(__FILE__)))

Vagrant.configure("2") do |config|
  config.vm.define vmname do |box|
    box.vm.box = "opscode-debian-7.4.0"
    box.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_debian-7.4.0_chef-provisionerless.box"
    box.vm.hostname = vmname

    box.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--cpuexecutioncbox", "50"]
      v.customize ["modifyvm", :id, "--memory", 128]
    end

    box.ssh.forward_agent = true

    box.vm.provision :shell do |s|
      s.inline = "apt-get update && apt-get --yes install git finger gnupg haveged"
    end
  end
end
