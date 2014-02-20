# We'll mount the Chef::Config[:file_cache_path] so it persists between
# Vagrant VMs
host_cache_path = File.expand_path("../.cache", __FILE__)
guest_cache_path = "/tmp/vagrant-cache"

# ensure the cache path exists
FileUtils.mkdir(host_cache_path) unless File.exist?(host_cache_path)

Vagrant.configure("2") do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu-server-13.04"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.provisioning_path = guest_cache_path
    chef.log_level         = :debug

    chef.json = {
        "java" => {
            'install_flavor' => 'openjdk',
            'jdk_version' => '7'
        },
        "mysql" => {
            "server_root_password" => "iloverandompasswordsbutthiswilldo",
            "server_repl_password" => "iloverandompasswordsbutthiswilldo",
            "server_debian_password" => "iloverandompasswordsbutthiswilldo",
            "bind_address" => "localhost",
            "tunable" => {
                "wait_timeout" => "28800"
            }
        }
    }

    chef.run_list = %w{
      recipe[bamboo]
    }
  end

  config.vm.synced_folder host_cache_path, guest_cache_path
end