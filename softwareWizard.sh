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
  sleep 5
}

obtaining_privileges() {
  # If not root, re-execute with sudo
  if [ "$(id -u)" -ne 0 ]; then
    exec sudo -E bash "$0" "$@"
  fi
  return 0
}

updating_system() {
  dots "Updating system packages..."
  sudo apt-get update && sudo apt-get upgrade -y
  print_success "System packages updated!"
  return 0
}

install_packages() {
  dots "Installing essential APT packages"
  sudo apt-get install -y --no-install-recommends vim neovim vlc git fastfetch openssh-client solaar curl wget
  sudo apt-get clean
  print_success "Installed packages!"
  return 0
}

install_google_chrome() {
    dots "Installing Google Chrome"
    
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

install_vscode() {
    dots "Installing Visual Studio Code"
    
    # Check if VS Code is already installed
    if command_exists code; then
      print_success "Visual Studio Code is already installed"
      return 0
    fi
    
    # Download VS Code
    if ! wget -O /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"; then
      print_error "Failed to download Visual Studio Code"
      return 1
    fi
    
    # Install VS Code
    if ! sudo DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/vscode.deb; then
      print_warning "dpkg installation failed, trying to fix dependencies"
      # Fix any dependency issues with noninteractive mode
      if ! sudo DEBIAN_FRONTEND=noninteractive apt --fix-broken install -y; then
        print_error "Failed to fix VS Code dependencies"
        rm -f /tmp/vscode.deb
        return 1
      fi
    fi
    
    # Clean up
    rm -f /tmp/vscode.deb
    
    print_success "Visual Studio Code installed successfully!"
    return 0
}

install_uv() {
    dots "Downloading and installing UV for Python"
    
    if ! curl -LsSf https://astral.sh/uv/install.sh | sh; then
      print_error "Failed to install UV"
      return 1
    fi
    
    dots "Restarting shell"
    
    if [ -f "$HOME/.local/bin/env" ]; then
      source "$HOME/.local/bin/env"
      print_success "UV installed successfully!"
    else
      print_warning "UV environment file not found"
    fi

    return 0
}

install_docker() {
  dots "Checking if Docker is already installed"
    
  # Check if Docker is already installed
  if command_exists docker; then
    print_success "Docker is already installed"
    return 0
  fi
    
  # Load OS information if not already loaded
  if [ -z "$ID" ]; then
    source /etc/os-release
  fi
    
  # Install Docker based on distribution
  if [[ "$ID" == "debian" ]] || [[ "$ID_LIKE" =~ debian ]]; then
    dots "Installing Docker for $ID"
    
    # Add Docker's official GPG key:

    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
        
    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
          
    # Install Docker
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        
    print_success "Docker installed successfully for Debian!"
        
  elif [[ "$ID" == "ubuntu" ]]; then
    dots "Installing Docker for $ID"

    # Add Docker's official GPG key:

    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt-get update

    # Install Docker

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    print_success "Docker installed successfully for Ubuntu!"
        
  else
    print_error "Docker installation not supported for this distribution: $ID"
    print_error "Debian and Ubuntu are only supported."
    return 1
  fi
    
  # Verify Docker installation
  if command_exists docker; then
    echo "Docker version:"
    docker --version
    print_success "Docker installation completed successfully!"
        
    # Add current user to docker group (optional)
    dots "Adding current user to docker group for access without root permissions"

    if sudo usermod -aG docker "$USER"; then
      print_success "User added to docker group."
      printf '%s\n' "When the script finishes, reopen the terminal for changes to take effect."
    else
      print_warning "Failed to add user to docker group"
    fi

  else
    print_error "Docker installation verification failed"
    return 1
  fi
  
  return 0
}

# Main execution
main() {
  welcome
  obtaining_privileges
  updating_system
  install_packages
  install_google_chrome
  install_vscode
  install_uv
  install_docker
  print_success "System setup completed successfully!"
  return 0
}

# Run main
main