#!/usr/bin/env bash

# Ensure this path is correct
source ./common.sh

welcome() {
    printf '%s\n' "                                                ";
    printf '                                   %s%s%s%s%s%s%s__   \n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    printf '   %s%s ____ ___  %s__  __  %s ____  %s_____%s/ /_  %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    printf '  %s%s / __ `__ \%s/ / / / %s /_  / %s/ ___/%s __ \ %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    printf ' %s%s / / / / / /%s /_/ / %s   / /_%s(__  )%s / / / %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    printf '%s%s /_/ /_/ /_/%s\__, / %s   /___/%s____/%s_/ /_/  %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    printf '          %s%s%s%s%s%s /____/%s                     %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    printf '%s\n' "                                                ";
    echo "Make sure you have MesloLGS NF Regular Nerd Font installed and set as your terminal font."
    echo "And you're running in your desired terminal"
    sleep 5
    return 0
}

ghostty_configs() {
    if command_exists ghostty; then
        dots "Adding ghostty configs"
        echo "theme = Homebrew" >> ~/.config/ghostty/config
        echo "bell-features = no-title,no-attention" >> ~/.config/ghostty/config
        echo "shell-integration-features = ssh-env" >> ~/.config/ghostty/config
        return 0
    else
        print_warning "Ghostty isn't installed yet, skipping configs"

        return 0
    fi
}

set_colors() {
    dots "Setting custom dircolors"

    cat > ~/.dircolors <<'EOF'
    # Directories (More contrast than blue)
    DIR 01;36
    # Symlinks and executables (optional)
    LINK 01;35
    EXEC 01;32
EOF

return 0
}

install_zsh() {
    dots  "Installing zsh shell"
    sudo apt update && sudo apt install -y zsh

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
    printf '%s\n' "Please restart your terminal to apply all changes."
    printf '%s\n' "zsh installation by z.sh"
}

main() {
    welcome
    ghostty_configs
    set_colors
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