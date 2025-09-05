#!/bin/bash

source ./common_functions.sh  # Ensure this path is correct

# Packages to install
PKGS=(vim git fastfetch openssh-client solaar curl wget)

# If not root, re-execute with sudo
if [ "$(id -u)" -ne 0 ]; then
  exec sudo -E bash "$0" "$@"
fi

apt-get update
apt-get install -y "${PKGS[@]}"

print_success "Installed packages: ${PKGS[*]}"
