#!/bin/bash

source ./common_functions.sh # Ensure this path is correct

welcome() {
    printf '                                   %s%s%s%s%s%s%s__   \n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    printf '   %s%s ____ ___  %s__  __  %s ____  %s_____%s/ /_  %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    printf '  %s%s / __ `__ \%s/ / / / %s /_  / %s/ ___/%s __ \ %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    printf ' %s%s / / / / / /%s /_/ / %s   / /_%s(__  )%s / / / %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    printf '%s%s /_/ /_/ /_/%s\__, / %s   /___/%s____/%s_/ /_/  %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    printf '          %s%s%s%s%s%s /____/%s                     %s\n' $RB_RED $RB_ORANGE $RB_YELLOW $RB_GREEN $RB_YELLOW $RB_GREEN $RB_VIOLET $RB_RESET
    echo ""
    echo "Make sure you have MesloLGS NF Regular Nerd Font installed and set as your terminal font."
    echo "And you're running in your desired terminal"
    sleep 5
    return 0
}

install_zsh() {
    sudo apt update && sudo apt upgrade -y
    sudo apt install zsh -y
    return 0
}

set_colors() {
    cat > ~/.dircolors <<'EOF'
    # Directories (More contrast than blue)
    DIR 01;36
    # Symlinks and executables (optional)
    LINK 01;35
    EXEC 01;32
EOF

return 0
}

activate_colors() {
    cat eval "$(dircolors -b ~/.dircolors)" > ~/.zshrc
    return 0
}

set_zsh_theme() {
    local theme="${1:-powerlevel10k/powerlevel10k}"
    sed -i "s/^ZSH_THEME=\".*\"/ZSH_THEME=\"$theme\"/" ~/.zshrc
    echo "zsh theme changed to: $theme"
    return 0
}

activate_zsh() {
    echo "Restarting zsh shell"
    source ~/.zshrc
    return 0
}

install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    return 0
}

main() {
    welcome
    install_zsh
    set_colors
    activate_colors
    set_zsh_theme
    activate_zsh
    install_oh_my_zsh
}

main