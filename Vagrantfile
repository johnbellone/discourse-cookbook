Vagrant.configure('2') do |config|
  # Configure specific Vagrant plugins if they are installed. In this
  # particular case we are using the Omnibus installation for Chef,
  # and caching for Vagrant.
  config.omnibus.chef_version = :latest if Vagrant.has_plugin?('vagrant-omnibus')
  config.cache.auto_detect = true if Vagrant.has_plugin?('vagrant-cachier')
  config.berkshelf.enabled = true if Vagrant.has_plugin?('vagrant-berkshelf')

  # Default to the bento boxes that Chef provides. These do not have
  # any software installed on them. But let's allow easy overrides.
  config.vm.box = ENV.fetch('VAGRANT_VM_BOX', 'opscode-ubuntu-14.04')
  config.vm.box_url = ENV.fetch('VAGRANT_VM_BOX_URL', 'http://s3.amazonaws.com/opscode-vm-bento/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box')

  # Configure the VM provider to give us a little more horsepower.
  config.vm.provider :virtualbox do |vb|
    vb.memory = ENV.fetch('VAGRANT_VM_MEMORY', 1028)
    vb.cpus = ENV.fetch('VAGRANT_VM_CPUS', 2)
  end

  config.vm.provider :vmware_fusion do |vw|
    vw.vmx['memsize'] = ENV.fetch('VAGRANT_VM_MEMORY', 1028)
    vw.vmx['numvcpus'] = ENV.fetch('VAGRANT_VM_CPUS', 2)
  end

  config.vm.define :database do |guest|
    guest.vm.network :private_network, ip: '172.10.12.10'
    guest.vm.provision :chef_solo do |chef|
      chef.run_list = %w(recipe[postgresql::server])
      chef.json = {
        postgresql: {
          password: {
            postgres: ENV.fetch('POSTGRESQL_PASSWORD', 'chefchef')
          }
        }
      }
    end
  end

  config.vm.define :redis do |guest|
    guest.vm.network :private_network, ip: '172.10.12.11'
    guest.vm.provision :chef_solo do |chef|
      chef.run_list = %w(recipe[redisio::install])
    end
  end

  config.vm.define :discourse, primary: true do |guest|
    guest.vm.network :private_network, ip: '172.10.12.12'
    guest.vm.provision :chef_solo do |chef|
      chef.run_list = %w(recipe[discourse::default])
      chef.json = {
        redis: {
          servers: %w(172.10.12.10)
        }
      }
    end
  end
end
