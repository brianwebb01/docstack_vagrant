# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Web server, php, mysql, beanstalk etc
  config.vm.define "web" do |web|

    web.vm.box = "ubuntu/trusty64"
    web.vm.network "private_network", ip: "192.168.2.200"

    web.vm.synced_folder "./", "/vagrant",
      owner: 'vagrant',
      group: 'www-data',
      mount_options: ["dmode=775,fmode=775"]

    web.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
    end

    db_pass = "Password1"
    db_name = "appdb"

    web.vm.provision :chef_solo do |chef|

      chef.cookbooks_path = "setup/vg_recipes/cookbooks"
      chef.roles_path     = "setup/vg_recipes/roles"
      chef.data_bags_path = "setup/vg_recipes/data_bags"

      chef.json = {
        :mysql => {
            :version => '5.5.40',
            :server_root_password => db_pass,
            :server_repl_password => db_pass,
            :server_debian_password => db_pass,
            :allow_remote_root => true,
            :remove_test_database => true,
            :bind_address => '0.0.0.0',
            :tunable => {
              :innodb_buffer_pool_size => "5MB"
            }
        }
      }

      chef.add_recipe "apt"
      chef.add_recipe "build-essential"
      chef.add_recipe "mysql::client"
      chef.add_recipe "mysql::server"
    end

    #web.vm.provision "shell", path:  "./setup/install-nginx-hhvm.sh"
    web.vm.provision "shell", path:  "./setup/install-nginx-phpfpm.sh"
    web.vm.provision "shell", path:  "./setup/install-beanstalkd.sh"
    web.vm.provision "shell", inline: "echo 'create database if not exists #{db_name}' | mysql -uroot -p#{db_pass}"
    web.vm.provision "shell", inline: "sudo usermod -a -G www-data vagrant"
    #web.vm.provision "shell", path:  "./setup/install-mongodb.sh"

  end #end web vm definition


  # #elasticsearch server
  # config.vm.define "search" do |search|

  #   search.vm.box = "ubuntu/trusty64"
  #   search.vm.network "private_network", ip: "192.168.2.201"

  #   search.vm.provider :virtualbox do |vb|
  #     vb.customize ["modifyvm", :id, "--memory", "512"]
  #   end

  #   search.vm.provision "shell" do |shell|
  #     shell.path = "./setup/install-elasticsearch.sh"
  #   end
  # end #end search vm definition

end
