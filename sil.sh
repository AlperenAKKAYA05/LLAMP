#!/bin/bash

# IonCube kaldırma
sudo rm $(php -i | grep "extension_dir" | grep -o "/.*")/ioncube_loader_lin_7.4.so
sudo service apache2 restart

# phpMyAdmin kaldırma
sudo rm -rf /usr/share/phpmyadmin
sudo rm /etc/apache2/sites-available/phpmyadmin.conf
sudo service apache2 restart

# MySQL kaldırma
sudo apt-get remove --purge mysql-server mysql-client mysql-common -y
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo rm -rf /var/lib/mysql

# Apache kaldırma
sudo apt-get remove --purge apache2 apache2-utils -y
sudo apt-get autoremove -y
sudo apt-get autoclean

# PHP kaldırma
sudo apt-get remove --purge php7.4 php7.4-common libapache2-mod-php7.4 php7.4-cli php7.4-gd php7.4-mysql php7.4-mbstring php7.4-curl php7.4-xml php7.4-zip php7.4-soap php7.4-intl php7.4-mcrypt -y
sudo apt-get autoremove -y
sudo apt-get autoclean

# SSH sunucusu kaldırma
sudo apt-get remove --purge openssh-server -y
sudo apt-get autoremove -y
sudo apt-get autoclean

# Letsencrypt kaldırma
sudo apt-get remove --purge python-certbot-apache -y
sudo apt-get autoremove -y
sudo apt-get autoclean

# FTP sunucusu kaldırma
sudo apt-get remove --purge proftpd -y
sudo apt-get autoremove -y
sudo apt-get autoclean

# Takas alanı kaldırma
sudo swapoff -v /swapfile
sudo rm /swapfile
sudo sed -i '/swapfile/d' /etc/fstab

# Imagick kaldırma
sudo apt-get remove --purge php7.4-imagick -y
sudo apt-get autoremove -y
sudo apt-get autoclean

echo "Kaldırma tamamlandı."
