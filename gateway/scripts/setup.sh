#! /bin/bash

echo "Starting..."

# Set Timezone To Asia/Kolkata
sudo timedatectl set-timezone Asia/Kolkata

# Update & Upgrade
sudo apt update
# sudo apt upgrade -y

# Install Basic Packages
sudo apt install dnsutils git htop ncdu neofetch -y

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Install Docker
sudo apt update
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo usermod -aG docker $USER

echo "Done!"
