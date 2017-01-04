#!/bin/bash

sudo su

export DEBIAN_FRONTEND=noninteractive

# Already Installed Directory HACK
mkdir -p /home/vagrant

# FORCE LOCALE
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8

echo -e "\n----- Startup ... \n"
apt-get update --fix-missing -y
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get autoremove -y

# Utils
if [ -f /home/vagrant/.utils ]
  then
  echo -e "\n----- Utils already installed... \n"
else
  touch /home/vagrant/.utils
  echo -e "\n----- Installing utils \n"
  apt-get -y install nano curl git software-properties-common > /dev/null 2>&1
  echo -e "Done!\n"
fi

# Apache 2.4
if [ -f /home/vagrant/.apache2 ]
then
  echo -e "\n----- Apache 2.4 already installed... \n"
else
  touch /home/vagrant/.apache2
  echo -e "\n----- Installing Apache 2.4... \n"
  apt-get install -y apache2 apache2-utils
  /lib/systemd/systemd-sysv-install enable apache2
  systemctl restart apache2
  echo -e "Done!\n"
fi

# PHP 7
if [ -f /home/vagrant/.php7 ]
then
  echo -e "\n----- PHP 7.0 already installed... \n"
else
  touch /home/vagrant/.php7
  echo -e "\n----- Installing PHP 7.0... \n"
  apt-get install -y php7.0-fpm php7.0-mysql php7.0-common php7.0-gd php7.0-json php7.0-cli php7.0-curl libapache2-mod-php7.0 php7.0-mbstring php-apcu
  a2enmod php7.0 rewrite deflate filter proxy_fcgi setenvif
  cp /nfs-www/_conf/_www.conf /etc/php/7.0/fpm/pool.d/www.conf
  chmod 0644 /etc/php/7.0/fpm/pool.d/www.conf
  cp /nfs-www/_conf/_php7.conf /etc/apache2/conf-available/php7.0-fpm.conf
  chmod 0644 /etc/apache2/conf-available/php7.0-fpm.conf
  systemctl restart apache2
  systemctl start php7.0-fpm
  systemctl restart apache2
  echo -e "Done!\n"
fi

echo -e "\n----- Removing old domains... \n"
shopt -s extglob
rm /etc/apache2/sites-available/!(000-default.conf|default-ssl.conf)
rm /etc/apache2/sites-enabled/!(000-default.conf|default-ssl.conf)
shopt -u extglob
echo -e "Done!\n"

echo -e "\n----- Creating domains... \n"
for VHOST in "/nfs-www/_vhosts/"/*
do
  confname=`basename $VHOST`
  filename="${confname%.*}"
  echo -e "\n----- Creating new domain $filename... \n"
  mkdir -p /var/www/$filename/public
  cp $VHOST /etc/apache2/sites-available/$confname
  sed -i s,/var/www/public,/var/www/$VHOST/public,g /etc/apache2/sites-available/$confname
  chmod 0644 /etc/apache2/sites-available/$confname
  a2ensite $confname
done
echo -e "Done!\n"
systemctl restart apache2

# MARIADB
if [ -f /home/vagrant/.maria10 ]
then
  echo -e "\n----- MariaDB 10.1 already installed... \n"
  exit 0
else
  echo -e "\n----- Installing MariaDB 10.1... \n"
  touch /home/vagrant/.maria10
  apt-get update
  debconf-set-selections <<< "mariadb-server-10.1 mysql-server/data-dir select ''"
  debconf-set-selections <<< "mariadb-server-10.1 mysql-server/root_password password 123"
  debconf-set-selections <<< "mariadb-server-10.1 mysql-server/root_password_again password 123"
  apt-get install -y mariadb-server mariadb-client > /dev/null 2>&1
  sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf
  mysql --user="root" --password="123" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY '123' WITH GRANT OPTION;"
  service mysql restart
  mysql --user="root" --password="123" -e "CREATE USER 'ubuntu'@'0.0.0.0' IDENTIFIED BY '123';"
  mysql --user="root" --password="123" -e "GRANT ALL ON *.* TO 'ubuntu'@'0.0.0.0' IDENTIFIED BY '123' WITH GRANT OPTION;"
  mysql --user="root" --password="123" -e "GRANT ALL ON *.* TO 'ubuntu'@'%' IDENTIFIED BY '123' WITH GRANT OPTION;"
  mysql --user="root" --password="123" -e "FLUSH PRIVILEGES;"
  service mysql restart
  /lib/systemd/systemd-sysv-install enable mysql
  echo -e "Done!\n"
fi

# Redis
if [ -f /home/vagrant/.redis ]
then
  echo -e "\n----- Redis already installed... \n"
else
  touch /home/vagrant/.redis
  echo -e "\n----- Installing Redis... \n"
  apt-get -qq update
  apt-get install -y redis-server > /dev/null 2>&1
  echo -e "Done!\n"
fi

# COMPOSER
if [ -f /home/vagrant/.composer ]
then
    echo -e "\n----- Composer already installed... \n"
else
  touch /home/vagrant/.composer
  echo -e "\n----- Installing Composer... \n"
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
  echo -e "Done!\n"
fi

# NODE | NPM
if [ -f /home/vagrant/.node-npm ]
then
    echo -e "\n----- Node & NPM already installed... \n"
    exit 0
fi
touch /home/vagrant/.node-npm
echo -e "\n----- Installing Node & NPM... \n"
curl -sL https://deb.nodesource.com/setup_7.x | bash -
apt-get install -y nodejs > /dev/null 2>&1
echo -e "Done!\n"

# GRUNT | BOWER
if [ -f /home/vagrant/.grunt-bower ]
then
    echo -e "\n----- Grunt & Bower already installed... \n"
    exit 0
fi
touch /home/vagrant/.grunt-bower
echo -e "\n----- Installing Grunt & Bower... \n"
npm install -g grunt-cli bower
echo -e "Done!\n"

# TIMEZONE
echo -e "\n----- Timezone... \n"
echo "Europe/Rome" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
echo -e "Done!\n"