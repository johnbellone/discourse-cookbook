Vagrant.configure('2') do |config|
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.box = ENV.fetch('VAGRANT_BOX', 'opscode-ubuntu-14.04')
  config.vm.box_url = ENV.fetch('VAGRANT_BOX_URL', 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box')

  config.vm.provider :virtualbox do |vb|
    vb.memory = 1024
    vb.cpus = 2
  end

  config.vm.define :database do |guest|
    guest.vm.network :private_network, ip: '172.10.12.10'
    guest.vm.provision :chef_solo do |chef|
      chef.run_list = %w(recipe[postgresql::server])
      chef.json = {
        postgresql: {
          password: ENV.fetch('POSTGRESQL_PASSWORD', 'chefchef')
        }
      }
    end
  end

  config.vm.define :redis do |guest|
    guest.vm.network :private_network, ip: '172.10.12.11'
    guest.vm.provision :chef_solo do |chef|
      chef.run_list = %w(recipe[redisio::install] recipe[redisio::enable])
    end
  end

  config.vm.define :discourse, primary: true do |guest|
    guest.vm.network :private_network, ip: '172.10.12.12'
    guest.vm.provision :chef_solo do |chef|
      chef.run_list = %w(recipe[discourse::default])
    end
  end
end
