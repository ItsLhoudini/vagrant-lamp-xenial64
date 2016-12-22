# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vbguest.auto_update = true
    config.vbguest.no_remote = false
    config.ssh.forward_agent = true

    config.vm.provider :virtualbox do |vb|
        vb.memory = "1024"
        vb.name = "ubuntu16.04_apache2.4_php7.0_mariadb10.1"
    end

    config.vm.box = "ubuntu/xenial64"

    config.vm.network "private_network", ip: "192.168.33.10"
    config.vm.synced_folder "./websites", "/nfs-www/websites", type: "nfs", create: true
    config.vm.synced_folder "./_conf", "/nfs-www/_conf", type: "nfs"
    config.vm.synced_folder "./_vhosts", "/nfs-www/_vhosts", type: "nfs"
    config.nfs.map_uid = Process.uid
    config.nfs.map_gid = Process.gid
    config.bindfs.bind_folder "/nfs-www/websites", "/var/www", perms: "u=rwX:g=rwX:o=rD", user: "www-data", group: "www-data"

    config.vm.provision "shell", path: "bootstrap.sh"

end