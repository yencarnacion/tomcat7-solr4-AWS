# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "dummyAWS"

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']

    # us-east-1 64bit Ubuntu 12.04.2 LTS (Precise Pangolin)
    aws.region="us-east-1"
    aws.ami = "ami-7747d01e"
    aws.security_groups = ['vagrant']

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "/Users/yamir/.ssh/yencarnacion_key.pem"
  end

  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.provision :chef_client do |chef|
     chef.validation_client_name = "webninjapr-validator"
     chef.client_key_path ="/Users/yamir/Dropbox/Stuff/WebNinjaCorp/Other/Digital-ID/chef-opscode/yencarnacionATwebninjapr_com.pem"
     chef.chef_server_url = "https://api.opscode.com/organizations/webninjapr"
     chef.validation_key_path = "/Users/yamir/Dropbox/Stuff/WebNinjaCorp/Other/Digital-ID/chef-opscode/webninjapr_com/webninjapr-validator.pem"
  end

  config.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = [ "cookbooks" ]
     chef.add_recipe "tomcat7-solr4"
     chef.log_level = :debug
  end
end

