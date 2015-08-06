Vagrant.configure(2) do |config|
  config.vm.define "docker-root"

  config.vm.box = "ailispaw/rancheros-lite"

  config.vm.provider :virtualbox do |vb|
    vb.memory = 2048
  end

  config.vm.hostname = "docker-root"

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ["nolock", "vers=3", "udp"]

  # Adjusting datetime before provisioning.
  config.vm.provision :shell, run: "always" do |sh|
    sh.inline = "sntp -4sSc pool.ntp.org; date"
  end
end
