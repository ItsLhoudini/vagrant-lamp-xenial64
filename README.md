# A Vagrant LAMP Stack
<br>

## Get Started
- Clone this [GitHub Repository](https://github.com/ItsLhoudini/vagrant-lamp-xenial64)
- Run `vagrant up`
- Take a coffee
- Access to your server at [http://192.168.33.10](http://192.168.33.10)

## Requirements
- [Vagrant](https://www.vagrantup.com/)
- Vagrant plugin [vagrant-bindfs](https://github.com/gael-ian/vagrant-bindfs)
- [Virtualbox](https://www.virtualbox.org/)
- Coffee machine

## Recommended
- Vagrant plugin [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)

<br>

## Features

### System Stuff
- Ubuntu 16.04 LTS (Xenial)
- Apache 2.4
- PHP 7.0 + FastCGI
- Git
- cURL
- Nano
- GD
- Composer
- Node
- NPM
- Mcrypt
- XML library

### Database Stuff
- MariaDB 10.1

### Caching Stuff
- Redis

### Node Stuff
- Grunt
- Bower

## Database Access

### MySQL
- Hostname: localhost or 127.0.0.1
- Username: ubuntu
- Password: 123

## SSH Access
- Hostname: 127.0.0.1:22
- Username: ubuntu
- SSH Key: `./vagrant/machines/default/virtualbox/private_key`

## Add/Modify vhost
- Add your custom .conf file inside `./_vhosts/` folder
- Run `vagrant provision`
- Take another coffee