#!/usr/bin/env bash

sudo apt update && sudo apt upgrade -y

sudo apt install -y keyd

sudo tee /etc/keyd/default.conf > /dev/null <<EOF
[ids]
*

[main]
leftshift = s
EOF

sudo systemctl restart keyd

sudo systemctl enable --now keyd
