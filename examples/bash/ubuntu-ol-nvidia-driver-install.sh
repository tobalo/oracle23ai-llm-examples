#!/bin/bash

# NVIDIA GPU Driver Installation and Ollama AI Configuration Script

# Step 1: Check GPU Devices
echo "Checking GPU devices..."
ubuntu-drivers devices

# Step 2: Install NVIDIA Library Packages
echo "Installing NVIDIA library packages..."
sudo apt update
sudo apt install libnvidia-common-535 libnvidia-gl-535 -y

# Step 3: Install NVIDIA Driver
echo "Installing NVIDIA driver..."
sudo apt install nvidia-driver-535-server -y

# Step 4: Reboot System
echo "Rebooting system for driver changes to take effect..."
sudo reboot

# The script will resume execution post-reboot

# Step 5: Validate Driver Installation
echo "Validating NVIDIA driver installation..."
nvidia-smi

# Step 6: Install Ollama AI Platform
echo "Installing Ollama AI platform..."
curl -fsSL https://ollama.com/install.sh | sh

# Step 7: Configure Ollama Service
echo "Configuring Ollama service..."
sudo tee -a /etc/systemd/system/ollama.service > /dev/null << EOF
[Service]
Environment=OLLAMA_HOST=0.0.0.0
Environment=OLLAMA_KEEP_ALIVE=-1
EOF

# Step 8: Open Firewall Port
echo "Opening firewall port for Ollama service..."
sudo iptables -A INPUT -p tcp --dport 11434 -j ACCEPT
sudo -s iptables-save -c

# Step 9: Reload and Restart Services
echo "Reloading systemd daemon and restarting Ollama service..."
sudo systemctl daemon-reload
sudo systemctl restart ollama.service

# Step 10: Check Service Status
echo "Checking Ollama service status..."
netstat -tulpn

# Step 11: Pull and Use a Model (Manual Step)
echo "NVIDIA driver installation and Ollama AI configuration completed."
echo "Now, you can pull and use a model of your choice with the following commands:"
echo "To pull a model: ollama pull <model_name>:<version>"
echo "To use the model: curl http://IP:11434/api/generate -d '{\"model\": \"<model_name>\", \"keep_alive\": -1}'"
