#!/usr/bin/env bash

set -e

echo "======================================"
echo " Updating Packages"
echo "======================================"

sudo apt update -y

echo "======================================"
echo " Installing Java 21"
echo "======================================"

sudo apt install -y openjdk-21-jdk-headless

java -version

echo "======================================"
echo " Installing Docker"
echo "======================================"

# Remove old docker packages
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# Install dependencies
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Create keyrings directory
sudo mkdir -p /etc/apt/keyrings

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index
sudo apt update -y

# Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose Plugin
sudo apt install docker-compose-plugin -y

# Enable Docker
sudo systemctl enable docker
sudo systemctl start docker

docker --version
docker compose version

echo "======================================"
echo " Installing Jenkins"
echo "======================================"

# Create keyrings directory
sudo mkdir -p /etc/apt/keyrings

# Add Jenkins key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | \
sudo tee /etc/apt/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package index
sudo apt update -y

# Install Jenkins
sudo apt install -y jenkins

# Enable Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "======================================"
echo " Adding Jenkins User to Docker Group"
echo "======================================"

sudo usermod -aG docker jenkins

# Restart services
sudo systemctl restart docker
sudo systemctl restart jenkins

echo "======================================"
echo " Checking Services"
echo "======================================"

sudo systemctl status docker --no-pager
sudo systemctl status jenkins --no-pager

