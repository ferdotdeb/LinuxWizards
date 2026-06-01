#!/usr/bin/env bash

source ./src/common.sh
source ./src/welcome/welcome_zsh.sh

ghostty_configs() {
    if command_exists ghostty; then
        dots "Adding ghostty configs"
        printf '%s\n' "theme = Vercel" >> ~/.config/ghostty/config
        printf '%s\n' "bell-features = no-title,no-attention" >> ~/.config/ghostty/config
        printf '%s\n' "shell-integration-features = ssh-env" >> ~/.config/ghostty/config
        return 0
    else
        print_warning "Ghostty isn't installed yet, skipping configs"

        return 0
    fi
}

install_zsh() {
    dots  "Installing zsh shell"
    sudo apt-get install -y zsh

    return 0
}

setup_zsh_theme() {
    dots "Setting zsh theme to powerlevel10k in .zshrc"

    local theme="${1:-powerlevel10k/powerlevel10k}"
    sed -i "s/^ZSH_THEME=\".*\"/ZSH_THEME=\"$theme\"/" ~/.zshrc
    print_success "zsh theme changed to: $theme"
    
    return 0
}

activate_zsh() {
    dots "Restarting zsh shell"
    source ~/.zshrc
    
    return 0
}

install_oh_my_zsh() {
    dots "Installing ohmyzsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
    return 0
}

install_pl10k_theme() {
    dots "Installing powerlevel10k theme"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    return 0
}

finish_setup() {
    print_success "zsh setup complete!"
    printf '%s\n' "Please restart your terminal to apply all changes"
    printf '%s\n' "zsh installation by z.sh"
}

main() {
    welcome
    ghostty_configs
    install_zsh
    setup_zsh_theme
    activate_zsh
    install_oh_my_zsh
    install_pl10k_theme
    finish_setup
    
    return 0
}

# Run main
main