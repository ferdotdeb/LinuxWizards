#!/usr/bin/env bash

source ./src/common.sh
source ./src/software/welcome.sh

update_system

install_packages() {
  dots "Installing essential APT packages"
  sudo apt-get install -y --no-install-recommends vim vlc git fastfetch openssh-client solaar curl wget libfuse2
  sudo apt-get clean
  print_success "Installed packages!"
  
  return 0
}

install_uv() {
  dots "Installing UV for Python"
    
  curl -LsSf https://astral.sh/uv/install.sh | sh
    
  dots "Restarting shell"
    
  source "$HOME/.local/bin/env"
  
  print_success "UV installed and activated!"
  
  return 0
}

install_agents() {
  dots "Installing OpenCode"
  curl -fsSL https://opencode.ai/install | bash

  dots "Installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash

  return 0
}

manual_links() {
  printf '%s\n' "This software requires manual installation"
  printf '%s\n' "Please visit the following links to download and install them:"

  printf '%s\n' "Node.js:"
  print_link "https://nodejs.org/es/download"
  printf '\n'

  printf '%s\n' "Docker:"
  print_link "https://docs.docker.com/engine/"
  printf '\n'

  printf '%s\n' "Spotify:"
  print_link "https://www.spotify.com/mx/download/linux/"
  printf '\n'

  printf '%s\n' "Visual Studio Code:"
  print_link "http://code.visualstudio.com/"
  printf '\n'

  printf '%s\n' "Cursor:"
  print_link "https://cursor.com/download"
  printf '\n'

  return 0
}

# Main execution
main() {
  welcome
  update_system
  install_packages
  install_uv
  install_agents
  manual_links
  print_success "System setup completed successfully!"
  printf '%s\n' "Software installation by softwareWizard.sh"
  
  return 0
}

# Run main
main