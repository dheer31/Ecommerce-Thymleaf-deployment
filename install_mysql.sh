#!/bin/bash

set -e

echo "======================================="
echo " Updating System"
echo "======================================="
sudo apt update
sudo apt upgrade -y

echo "======================================="
echo " Installing MySQL Server"
echo "======================================="
sudo apt install mysql-server -y

echo "======================================="
echo " MySQL Version"
echo "======================================="
mysql --version

echo "======================================="
echo " Starting MySQL Service"
echo "======================================="
sudo systemctl enable mysql
sudo systemctl start mysql

echo "======================================="
echo " Configuring MySQL Root User"
echo "======================================="

sudo mysql <<EOF
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "======================================="
echo " Configuring Remote Access"
echo "======================================="

CONFIG_FILE="/etc/mysql/mysql.conf.d/mysqld.cnf"

sudo sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' $CONFIG_FILE

echo "======================================="
echo " Restarting MySQL"
echo "======================================="
sudo systemctl restart mysql

echo "======================================="
echo " Checking MySQL Status"
echo "======================================="
sudo systemctl status mysql --no-pager

echo "======================================="
echo " MySQL Installation Completed"
echo "======================================="
echo "Remote User : root"
echo "Password    : 1234"
echo "Port        : 3306"

echo ""
echo "If connecting from another machine,"
echo "make sure port 3306 is allowed in your firewall/security group."
