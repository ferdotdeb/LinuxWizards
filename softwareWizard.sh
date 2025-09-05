#!/bin/bash

source ./common_functions.sh  # Ensure this path is correct

welcome() {
  echo "                                                                                                                     ";
  echo "███████╗ ██████╗ ███████╗████████╗██╗    ██╗ █████╗ ██████╗ ███████╗    ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ ";
  echo "██╔════╝██╔═══██╗██╔════╝╚══██╔══╝██║    ██║██╔══██╗██╔══██╗██╔════╝    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗";
  echo "███████╗██║   ██║█████╗     ██║   ██║ █╗ ██║███████║██████╔╝█████╗      ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║";
  echo "╚════██║██║   ██║██╔══╝     ██║   ██║███╗██║██╔══██║██╔══██╗██╔══╝      ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║";
  echo "███████║╚██████╔╝██║        ██║   ╚███╔███╔╝██║  ██║██║  ██║███████╗    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝";
  echo "╚══════╝ ╚═════╝ ╚═╝        ╚═╝    ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝     ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ";
  echo "                                                                                                                     ";
}

install_apt_packages() {
  # Packages to install
  PKGS=(vim git fastfetch openssh-client solaar curl wget)

  # If not root, re-execute with sudo
  if [ "$(id -u)" -ne 0 ]; then
    exec sudo -E bash "$0" "$@"
  fi

  apt-get update
  apt-get install -y "${PKGS[@]}"

  print_success "Installed packages: ${PKGS[*]}"
}

install_google_chrome() {
    echo "Installing Google Chrome..."
    
    # Check if Chrome is already installed
    if command_exists google-chrome; then
        print_success "Google Chrome is already installed"
        return 0
    fi
    
    # Download Chrome
    if ! wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb; then
        print_error "Failed to download Google Chrome"
        return 1
    fi
    
    # Install Chrome
    if ! sudo dpkg -i /tmp/chrome.deb; then
        print_warning "dpkg installation failed, trying to fix dependencies"
        # Fix any dependency issues
        if ! sudo apt --fix-broken install -y; then
            print_error "Failed to fix Chrome dependencies"
            rm -f /tmp/chrome.deb
            return 1
        fi
    fi
    
    # Clean up
    rm -f /tmp/chrome.deb
    
    print_success "Google Chrome installed successfully!"
    return 0
}