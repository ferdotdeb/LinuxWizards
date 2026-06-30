#!/usr/bin/env bash

sudo apt update && sudo apt upgrade -y

sudo apt install -y keyd

# No config for all keyboards

sudo tee /etc/keyd/default.conf > /dev/null <<EOF
[ids]
*

[main]
EOF

# Config for integrated keyboard

sudo tee /etc/keyd/integrated.conf > /dev/null <<EOF
[ids]
0001:0001:09b4e68d

[main]
leftshift = s
EOF

sudo systemctl restart keyd

sudo systemctl enable --now keyd
