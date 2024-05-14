#!/bin/bash

# MySQL kurulumu
sudo apt-get install mysql-server

# Apache kurulumu
sudo apt-get install apache2

# PHP kurulumu
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-common php7.4-mbstring php7.4-xmlrpc php7.4-soap php7.4-gd php7.4-xml php7.4-intl php7.4-mysql php7.4-cli php7.4-mcrypt php7.4-zip php7.4-curl

# MySQL kök şifresini güncelleme
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"

# phpMyAdmin kurulumu
cd /usr/share
sudo wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.zip
sudo unzip phpMyAdmin-5.1.1-all-languages.zip
sudo mv phpMyAdmin-5.1.1-all-languages phpmyadmin
sudo chmod -R 755 phpmyadmin
sudo cp phpmyadmin/config.sample.inc.php phpmyadmin/config.inc.php

# Apache yapılandırması
sudo tee /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Apache yeniden başlatma
sudo service apache2 restart

# SSH sunucusu kurulumu
sudo apt-get install openssh-server

# Letsencrypt kurulumu
sudo add-apt-repository ppa:certbot/certbot
sudo apt install python-certbot-apache
sudo certbot --apache

# PHP sürümü ayarlama
sudo update-alternatives --config php

# Apache modül ayarlama
sudo a2enmod rewrite
sudo a2enmod ssl

# Port açma
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo netfilter-persistent save

# MySQL komutları
sudo mysql -e "CREATE USER 'root'@'localhost' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# FTP kurulumu
sudo apt-get install proftpd

# FTP yapılandırması
sudo tee /etc/proftpd/proftpd.conf <<EOF
<Limit LOGIN>
    AllowUser elinkgate
    DenyALL
</Limit>
DefaultRoot /var/www/html elinkgate
<Directory /var/www/html>
    Umask 022 022
    AllowOverwrite on
    <Limit MKD STOR XMKD RNRF RNTO RMD XRMD CWD>
        DenyAll
    </Limit>
    <Limit STOR CWD MKD>
        AllowAll
    </Limit>
</Directory>
EOF

# FTP yeniden başlatma
sudo service proftpd restart

# Takas alanı oluşturma
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# IonCube kurulumu
cd /tmp
sudo wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
sudo tar -zxvf ioncube_loaders_lin_x86-64.tar.gz
sudo cp ioncube/ioncube_loader_lin_7.4.so $(php -i | grep "extension_dir" | grep -o "/.*")/ioncube_loader_lin_7.4.so
echo "zend_extension = $(php -i | grep "extension_dir" | grep -o "/.*/")ioncube_loader_lin_7.4.so" | sudo tee -a /etc/php/7.4/cli/php.ini
sudo service apache2 restart

# Imagick kurulumu
sudo apt install imagemagick
sudo apt install php7.4-imagick

echo "Kurulum tamamlandı."
