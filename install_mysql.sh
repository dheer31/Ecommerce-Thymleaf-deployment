#!/bin/bash

set -e

echo "========================================="
echo "      MySQL Installation Script"
echo "========================================="

# Update system
echo "[1/8] Updating packages..."
sudo apt update
sudo apt upgrade -y

# Install MySQL
echo "[2/8] Installing MySQL Server..."
sudo apt install -y mysql-server

# Enable and start MySQL
echo "[3/8] Starting MySQL..."
sudo systemctl enable mysql
sudo systemctl start mysql

# Configure MySQL root user
echo "[4/8] Configuring MySQL root user..."

sudo mysql <<EOF
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

CONFIG_FILE="/etc/mysql/mysql.conf.d/mysqld.cnf"

echo "[5/8] Configuring bind-address..."

if [ -f "$CONFIG_FILE" ]; then

    # Update or add bind-address
    if grep -q "^bind-address" "$CONFIG_FILE"; then
        sudo sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' "$CONFIG_FILE"
    else
        echo "bind-address = 0.0.0.0" | sudo tee -a "$CONFIG_FILE"
    fi

    # Update or add mysqlx-bind-address
    if grep -q "^mysqlx-bind-address" "$CONFIG_FILE"; then
        sudo sed -i 's/^mysqlx-bind-address.*/mysqlx-bind-address = 0.0.0.0/' "$CONFIG_FILE"
    else
        echo "mysqlx-bind-address = 0.0.0.0" | sudo tee -a "$CONFIG_FILE"
    fi

else
    echo "Configuration file not found!"
    exit 1
fi

# Open firewall if UFW exists
echo "[6/8] Configuring Firewall..."

if command -v ufw >/dev/null 2>&1; then
    sudo ufw allow 3306/tcp || true
fi

# Restart MySQL
echo "[7/8] Restarting MySQL..."
sudo systemctl restart mysql

# Verification
echo "[8/8] Verification"
echo "-----------------------------------------"

echo
echo "MySQL Version:"
mysql --version

echo
echo "MySQL Service:"
sudo systemctl --no-pager --full status mysql | head -10

echo
echo "Configuration:"
grep "bind-address" "$CONFIG_FILE"

echo
echo "Listening Ports:"
sudo ss -tlnp | grep 3306 || true

echo
echo "========================================="
echo "Installation Completed Successfully!"
echo "========================================="
echo
echo "Host     : <SERVER_IP>"
echo "Port     : 3306"
echo "Username : root"
echo "Password : 1234"
echo
echo "Use this command to test locally:"
echo "mysql -u root -p"
echo
