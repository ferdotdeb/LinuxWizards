#!/usr/bin/env bash

# Ensure this path is correct
source ./common.sh

welcome() {
  printf "${BLUE}                                                                                                                     ${RESET}\n";
  printf "${BLUE}███████╗ ██████╗ ███████╗████████╗██╗    ██╗ █████╗ ██████╗ ███████╗    ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ ${RESET}\n";
  printf "${BLUE}██╔════╝██╔═══██╗██╔════╝╚══██╔══╝██║    ██║██╔══██╗██╔══██╗██╔════╝    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗${RESET}\n";
  printf "${BLUE}███████╗██║   ██║█████╗     ██║   ██║ █╗ ██║███████║██████╔╝█████╗      ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║${RESET}\n";
  printf "${BLUE}╚════██║██║   ██║██╔══╝     ██║   ██║███╗██║██╔══██║██╔══██╗██╔══╝      ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║${RESET}\n";
  printf "${BLUE}███████║╚██████╔╝██║        ██║   ╚███╔███╔╝██║  ██║██║  ██║███████╗    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝${RESET}\n";
  printf "${BLUE}╚══════╝ ╚═════╝ ╚═╝        ╚═╝    ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝     ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ${RESET}\n";
  printf "${BLUE}                                                                                                                     ${RESET}\n";
  sleep 5

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
  sudo apt-get install -y --no-install-recommends vim vlc git fastfetch openssh-client solaar curl wget
  sudo apt-get clean
  print_success "Installed packages!"
  
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
  updating_system
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