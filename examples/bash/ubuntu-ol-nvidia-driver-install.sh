#!/bin/bash
# NVIDIA GPU Driver Installation and Ollama AI Configuration Script
# Step 1: Check GPU Devices
ubuntu-drivers devices

# Step 2: Install NVIDIA Library Packages
sudo apt update
sudo apt install libnvidia-common-535 libnvidia-gl-535 -y

# Step 3: Install NVIDIA Driver
sudo apt install nvidia-driver-535-server -y

# Step 4: Reboot System
sudo reboot

# Step 5: Validate Driver Installation
nvidia-smi

# Step 6: Install Ollama AI Platform
curl -fsSL https://ollama.com/install.sh | sh

# Step 7: Configure Ollama Service
sudo tee -a /etc/systemd/system/ollama.service > /dev/null << EOF
[Service]
Environment=OLLAMA_HOST=0.0.0.0
Environment=OLLAMA_KEEP_ALIVE=-1
EOF

# Step 8: Open Firewall Port
sudo iptables -A INPUT -p tcp --dport 11434 -j ACCEPT
sudo -s iptables-save -c

# Step 9: Reload and Restart Services
sudo systemctl daemon-reload
sudo systemctl restart ollama.service

# Step 10: Check Service Status
netstat -tulpn

# Step 11: Pull and Use a Model (Manual Step)
ollama pull <model_name>:<version>"
curl http://IP:11434/api/generate -d '{\"model\": \"<model_name>\", \"keep_alive\": -1}'"
