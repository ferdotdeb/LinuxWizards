#!/usr/bin/env bash

source ./src/common.sh
source ./src/software/welcome.sh

install_packages() {
  dots "Installing essential APT packages"
  sudo apt-get install -y --no-install-recommends vim vlc git fastfetch openssh-client solaar curl wget libfuse2
  sudo apt-get clean
  print_success "Installed packages!"
  
  return 0
}

install_dev_browsers() {
  dots "Installing Google Chrome"
  wget https://dl.google.com/linux/direct/google-chrome-unstable_current_amd64.deb
  sudo apt-get install -y ./google-chrome-unstable_current_amd64.deb
  rm google-chrome-unstable_current_amd64.deb
  print_success "Google Chrome installed"

  dots "Installing Firefox Developer Edition"
  sudo install -d -m 0755 /etc/apt/keyrings

  wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

  cat <<EOF | sudo tee /etc/apt/sources.list.d/mozilla.sources
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF

cat <<EOF | sudo tee /etc/apt/preferences.d/mozilla
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

  sudo apt-get update && sudo apt-get install -y firefox-devedition
  
  print_success "Firefox Developer Edition installed"

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
  dots "Installing AI Agents"
  
  while :; do
    read -erp "Install OpenCode? [Y/n] " ans
    case $ans in
        [Yy]*|"")
            dots "Installing OpenCode"
            curl -fsSL https://opencode.ai/install | bash
            if command_exists opencode; then
              print_success "OpenCode installed"
            else
              print_error "OpenCode is not available in PATH"
            fi
            break
            ;;
        [Nn]*)
            break
            ;;
        *)
            print_error "Invalid input, choose between y or n"
            ;;
      esac
  done

  while :; do
    read -erp "Install Claude Code? [Y/n] " ans
    case $ans in
        [Yy]*|"")
            dots "Installing Claude Code"
            curl -fsSL https://claude.ai/install.sh | bash
            if command_exists claude; then
              print_success "Claude Code installed"
            else
              print_error "Claude Code is not available in PATH"
            fi
            break
            ;;
        [Nn]*)
            break
            ;;
        *)
            print_error "Invalid input, choose between y or n"
            ;;
      esac
  done

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
  install_dev_browsers
  install_uv
  install_agents
  manual_links
  print_success "System setup completed successfully!"
  printf '%s\n' "Software installation by softwareWizard.sh"
  
  return 0
}

# Run main
main